#![allow(unused_imports)]
// #![allow(unused_variables)]
#![allow(unused_assignments)]
#![allow(dead_code)]
#![allow(unused_mut)]
#![allow(clippy::type_complexity)]
#![allow(non_camel_case_types)]
//#![feature(allocator_api)]
#[macro_use]
extern crate ndarray;
extern crate rayon;
extern crate rustfft;

extern crate nalgebra as na;
use na::{Matrix2, Matrix4};
use ndarray::prelude::*;
use ndarray::ArrayView;
use ndarray::*;
use ndarray::{concatenate, stack, Axis};
use std::thread;
// use ndarray_linalg::*;
use num::complex::Complex;
use pyo3::prelude::*;
use pyo3::types::IntoPyDict;
use pyo3::{wrap_pyfunction, wrap_pymodule};
use rayon::prelude::*;
use rustfft::FftPlanner;
use std::sync::Arc;
use std::time::{Duration, Instant};

use std::f64::consts::PI;

const I: num::complex::Complex<f64> = num::complex::Complex::new(0.0, 1.0);
pub const C1: num::complex::Complex<f64> = num::complex::Complex::new(1.0, 0.0);
const C0: num::complex::Complex<f64> = num::complex::Complex::new(0.0, 0.0);
const CPI: num::complex::Complex<f64> = num::complex::Complex::new(PI, 0.0);

type c64 = num::complex::Complex<f64>;

fn cmat_create(dip: f64, strike: f64, rupt: f64) -> [[c64; 3]; 3] {
    let mut cmat = [[num::complex::Complex { re: 0.0, im: 0.0 }; 3]; 3];
    let st: f64 = f64::sin(dip);
    let ct: f64 = f64::cos(dip);
    let s2t: f64 = f64::sin(2.0 * dip);
    let c2t: f64 = f64::cos(2.0 * dip);
    let sp: f64 = f64::sin(strike);
    let cp: f64 = f64::cos(strike);
    let sp2: f64 = f64::sin(strike).powi(2);
    let cp2: f64 = f64::cos(strike).powi(2);
    let s2p: f64 = f64::sin(2.0 * strike);
    let c2p: f64 = f64::cos(2.0 * strike);
    let sl: f64 = f64::sin(rupt);
    let cl: f64 = f64::cos(rupt);
    cmat[0][0] = num::complex::Complex::new(-sp2 * s2t * sl - s2p * st * cl, 0.0);
    cmat[0][1] = num::complex::Complex::new(0.5 * s2p * s2t * sl + c2p * st * cl, 0.0);
    cmat[1][0] = cmat[0][1];
    cmat[0][2] = num::complex::Complex::new(-sp * c2t * sl - cp * ct * cl, 0.0);
    cmat[2][0] = cmat[0][2];
    cmat[1][1] = num::complex::Complex::new(s2p * st * cl - cp2 * s2t * sl, 0.0);
    cmat[1][2] = num::complex::Complex::new(cp * c2t * sl - sp * ct * cl, 0.0);
    cmat[2][1] = cmat[1][2];
    cmat[2][2] = num::complex::Complex::new(s2t * sl, 0.0);
    cmat
}

fn tmatn_create(dip: f64, strike: f64) -> [[c64; 3]; 3] {
    let mut tmat = [[num::complex::Complex { re: 0.0, im: 0.0 }; 3]; 3];
    let st: f64 = f64::sin(dip);
    let ct: f64 = f64::cos(dip);
    let sp: f64 = f64::sin(strike);
    let cp: f64 = f64::cos(strike);
    // -- row1
    // -sp*ct , -cp , sp*st
    tmat[0][0] = num::complex::Complex::new(-sp * ct, 0.0);
    tmat[0][1] = num::complex::Complex::new(-cp, 0.0);
    tmat[0][2] = num::complex::Complex::new(sp * st, 0.0);
    // -- row2
    // cp*ct , -sp , -cp*st
    tmat[1][0] = num::complex::Complex::new(cp * ct, 0.0);
    tmat[1][1] = num::complex::Complex::new(-sp, 0.0);
    tmat[1][2] = num::complex::Complex::new(-cp * st, 0.0);
    // -- row3
    // st , o , ct
    tmat[2][0] = num::complex::Complex::new(st, 0.0);
    tmat[2][1] = num::complex::Complex::new(0.0, 0.0);
    tmat[2][2] = num::complex::Complex::new(ct, 0.0);
    tmat
}

#[pyclass]
struct Fault {
    angles: (f64, f64, f64),           // (dip, strike, rake)
    loc: (f64, f64, f64),              // (x_top, y_top, z_top)
    fpars: (f64, f64),                 // (df, max_freq)
    medium: Vec<(f64, f64, f64, f64)>, // (rho, ca, cb, h)
    conf: (i32, i32, f64, f64, f64),   // (max_nx, max_ny, Lx, Ly, decay)
    w: ndarray::Array1<c64>,
    w2: ndarray::Array1<c64>,
    krl: std::collections::HashMap<
        usize,
        (
            Array4<c64>,
            Array4<c64>,
            Array4<c64>,
            Array4<c64>,
            Array4<c64>,
            Array4<c64>,
            Array4<c64>,
            Array4<c64>,
            Array4<c64>,
            Array4<c64>,
            Array4<c64>,
            Array4<c64>,
        ),
    >,
}

#[pymethods]
impl Fault {
    #[new]
    pub fn new(
        angles: (f64, f64, f64),
        loc: (f64, f64, f64),
        fpars: (f64, f64),
        medium: Vec<(f64, f64, f64, f64)>,
        conf: (i32, i32, f64, f64, f64),
    ) -> Self {
        // let tic_init = Instant::now();

        // angular frequencies
        let ifreq: c64 = -I * fpars.0 / 2.0 * conf.4;
        let mut w_vec = Vec::<c64>::new();
        let mut wi: f64 = 0.0;
        loop {
            w_vec.push(2.0 * CPI * (wi + ifreq));
            wi += fpars.0;
            if wi > fpars.1 {
                break;
            }
        }

        let w = ArrayView::from_shape(w_vec.len(), &w_vec).unwrap();
        let w = (1.0 + 0.0 * I) * &w;
        let w2 = &w * &w;

        // kx and ky
        let lx = conf.2;
        let ly = conf.3;

        let cmat = cmat_create(angles.0, angles.1, angles.2);
        // let tmat90 = tmatn_create(angles.0, angles.1);

        let krl: std::collections::HashMap<
            usize,
            (
                Array4<c64>,
                Array4<c64>,
                Array4<c64>,
                Array4<c64>,
                Array4<c64>,
                Array4<c64>,
                Array4<c64>,
                Array4<c64>,
                Array4<c64>,
                Array4<c64>,
                Array4<c64>,
                Array4<c64>,
            ),
        > = (0..w_vec.len())
            .into_par_iter()
            .map(|ukey| {
                let mut kmax = 0.0;
                let nm = medium.len(); // number of layers
                if (w_vec[ukey]).re > 2.0 * PI {
                    kmax = 4.0 * (w_vec[ukey]).re / medium[nm - 1].1; // testing
                } else {
                    kmax = 6.0;
                }

                let nx_max = (lx * kmax / (2.0 * PI)) as usize;
                let ny_max = (ly * kmax / (2.0 * PI)) as usize;

                // println!("nx = {} , ny = {}",nx_max,ny_max);

                let mut kx_vec = Vec::<c64>::new();
                let mut ky_vec = Vec::<c64>::new();

                kx_vec.push(num::complex::Complex::new(1e-06, 0.0));
                ky_vec.push(num::complex::Complex::new(1e-06, 0.0));

                for i in 1..=usize::min(conf.0 as usize, nx_max) {
                    kx_vec.push(num::complex::Complex::new(-2.0 * PI * (i as f64) / lx, 0.0));
                    kx_vec.push(num::complex::Complex::new(2.0 * PI * (i as f64) / lx, 0.0));
                }
                for j in 1..=usize::min(conf.1 as usize, ny_max) {
                    ky_vec.push(num::complex::Complex::new(-2.0 * PI * (j as f64) / ly, 0.0));
                    ky_vec.push(num::complex::Complex::new(2.0 * PI * (j as f64) / ly, 0.0));
                }
                let kx_arr = ArrayView::from_shape((1, kx_vec.len(), 1, 1), &kx_vec).unwrap();
                let ky_arr = ArrayView::from_shape((1, 1, ky_vec.len(), 1), &ky_vec).unwrap();

                // med1 : velocities of p-waves
                let mut med1_vec = Vec::<c64>::new();
                for med1_it in &medium {
                    med1_vec.push(num::complex::Complex::new(med1_it.1, 0.0));
                }

                // med2 : velocities of s-waves
                let mut med2_vec = Vec::<c64>::new();
                for med2_it in &medium {
                    med2_vec.push(num::complex::Complex::new(med2_it.2, 0.0));
                }

                // med2 : thicknesses
                let mut med3_vec = Vec::<c64>::new();
                for med3_it in &medium {
                    med3_vec.push(num::complex::Complex::new(med3_it.3, 0.0));
                }

                // med1 : velocities of p-waves
                let med1 = ArrayView::from_shape((medium.len(), 1, 1, 1), &med1_vec).unwrap();
                // med2 : thicknesses
                let med2 = ArrayView::from_shape((medium.len(), 1, 1, 1), &med2_vec).unwrap();
                // let med3 = ArrayView::from_shape((medium.len(),1,1,1),&med3_vec).unwrap();

                // mu_vec : rho * cb ** 2
                let mut mu_vec = Vec::<f64>::new();
                for mu_it in &medium {
                    mu_vec.push(mu_it.0 * mu_it.2 * mu_it.2);
                }

                // println!("{:?}", mu_vec);

                let kx_ky = &kx_arr * &ky_arr;
                let kx2 = &kx_arr * &kx_arr;
                let ky2 = &ky_arr * &ky_arr;
                let k2 = &kx2 + &ky2;
                let k = k2.mapv(c64::sqrt);

                // nu and gamma
                let nu2 = w2[ukey] / (&med1 * &med1) - &k2;
                let mut nu = nu2.mapv(c64::sqrt);
                for it in nu.iter_mut() {
                    if it.im > 0.0 {
                        *it = num::complex::Complex::conj(it);
                    }
                }
                let gm2 = w2[ukey] / (&med2 * &med2) - &k2;
                let mut gm = gm2.mapv(c64::sqrt);
                for it in gm.iter_mut() {
                    if it.im > 0.0 {
                        *it = num::complex::Complex::conj(it);
                    }
                }

                // cb**2
                let cb2 = &med2 * &med2;
                // let li = num::complex::Complex::new(2.0, 0.0) * &k2 - w2[ukey] / &cb2;

                // constant
                let a_const = &cb2 / (w2[ukey] * lx * ly);

                // reflections ---------------
                let kb2m2k2 = w2[ukey] / &cb2 - &k2 * 2.0;
                let kb2m2k2_2 = &kb2m2k2 * &kb2m2k2;
                let k2nugm4 = &k2 * &nu * &gm * 4.0;
                let det_gm = &k2nugm4 + &kb2m2k2_2;

                let g11 = kb2m2k2_2 - k2nugm4;
                let g12 = &k * &gm * &kb2m2k2 * (-4.0);
                let g21 = &k * &nu * &kb2m2k2 * 4.0;

                // -- layers 1,2 --

                let mut tmp12 = None;
                let mut tmpr12 = None;
                if nm > 1 {
                    // row1 : [ik, -iγ, -ik, -iγ]
                    let tmp12_row1 = concatenate(
                        Axis(2),
                        &[
                            (I * &k.slice(s![0, .., .., ..])).view(),
                            (-I * &gm.slice(s![1, .., .., ..])).view(),
                            (-I * &k.slice(s![0, .., .., ..])).view(),
                            (-I * &gm.slice(s![0, .., .., ..])).view(),
                        ],
                    )
                    .unwrap();

                    // row2 : [iν, ik, iν, -ik]
                    let tmp12_row2 = concatenate(
                        Axis(2),
                        &[
                            (I * &nu.slice(s![1, .., .., ..])).view(),
                            (I * &k.slice(s![0, .., .., ..])).view(),
                            (I * &nu.slice(s![0, .., .., ..])).view(),
                            (-I * &k.slice(s![0, .., .., ..])).view(),
                        ],
                    )
                    .unwrap();

                    // row3 : [2kνμ, -(kb^2-2k^2)μ, 2kνμ, (kb^2-2k^2)μ]
                    let tmp12_row3 = concatenate(
                        Axis(2),
                        &[
                            ((num::complex::Complex::new(2.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &k
                                * &nu)
                                .slice(s![1, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(-1.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![1, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(0).unwrap(), 0.0)
                                * &k
                                * &nu)
                                .slice(s![0, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(1.0 * mu_vec.get(0).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![0, .., .., ..]))
                                .view(),
                        ],
                    )
                    .unwrap();

                    // row4 : [(kb^2-2k^2)μ, 2kγμ, -(kb^2-2k^2)μ, 2kγμ]
                    let tmp12_row4 = concatenate(
                        Axis(2),
                        &[
                            (num::complex::Complex::new(1.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![1, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &k
                                * &gm)
                                .slice(s![1, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(-1.0 * mu_vec.get(0).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![0, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(0).unwrap(), 0.0)
                                * &k
                                * &gm)
                                .slice(s![0, .., .., ..]))
                            .view(),
                        ],
                    )
                    .unwrap();

                    // row1 : [ik, -iγ, -ik, -iγ]
                    let tmpr12_row1 = concatenate(
                        Axis(2),
                        &[
                            (I * &k.slice(s![0, .., .., ..])).view(),
                            (-I * &gm.slice(s![0, .., .., ..])).view(),
                            (-I * &k.slice(s![0, .., .., ..])).view(),
                            (-I * &gm.slice(s![1, .., .., ..])).view(),
                        ],
                    )
                    .unwrap();

                    // row2 : [iν, ik, iν, -ik]
                    let tmpr12_row2 = concatenate(
                        Axis(2),
                        &[
                            (I * &nu.slice(s![0, .., .., ..])).view(),
                            (I * &k.slice(s![0, .., .., ..])).view(),
                            (I * &nu.slice(s![1, .., .., ..])).view(),
                            (-I * &k.slice(s![0, .., .., ..])).view(),
                        ],
                    )
                    .unwrap();

                    // row3 : [2kνμ, -(kb^2-2k^2)μ, 2kνμ, (kb^2-2k^2)μ]
                    let tmpr12_row3 = concatenate(
                        Axis(2),
                        &[
                            ((num::complex::Complex::new(2.0 * mu_vec.get(0).unwrap(), 0.0)
                                * &k
                                * &nu)
                                .slice(s![0, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(-1.0 * mu_vec.get(0).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![0, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &k
                                * &nu)
                                .slice(s![1, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(1.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![1, .., .., ..]))
                                .view(),
                        ],
                    )
                    .unwrap();

                    // row4 : [(kb^2-2k^2)μ, 2kγμ, -(kb^2-2k^2)μ, 2kγμ]
                    let tmpr12_row4 = concatenate(
                        Axis(2),
                        &[
                            (num::complex::Complex::new(1.0 * mu_vec.get(0).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![0, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(0).unwrap(), 0.0)
                                * &k
                                * &gm)
                                .slice(s![0, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(-1.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![1, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &k
                                * &gm)
                                .slice(s![1, .., .., ..]))
                            .view(),
                        ],
                    )
                    .unwrap();

                    tmp12 = Some(stack![
                        Axis(2),
                        tmp12_row1,
                        tmp12_row2,
                        tmp12_row3,
                        tmp12_row4
                    ]);
                    tmpr12 = Some(stack![
                        Axis(2),
                        tmpr12_row1,
                        tmpr12_row2,
                        tmpr12_row3,
                        tmpr12_row4
                    ]);
                }

                // -- layers 2,3 --
                let mut tmp23 = None;
                let mut tmpr23 = None;
                if nm == 3 {
                    // row1 : [ik, -iγ, -ik, -iγ]
                    let tmp23_row1 = concatenate(
                        Axis(2),
                        &[
                            (I * &k.slice(s![0, .., .., ..])).view(),
                            (-I * &gm.slice(s![2, .., .., ..])).view(),
                            (-I * &k.slice(s![0, .., .., ..])).view(),
                            (-I * &gm.slice(s![1, .., .., ..])).view(),
                        ],
                    )
                    .unwrap();

                    // row2 : [iν, ik, iν, -ik]
                    let tmp23_row2 = concatenate(
                        Axis(2),
                        &[
                            (I * &nu.slice(s![2, .., .., ..])).view(),
                            (I * &k.slice(s![0, .., .., ..])).view(),
                            (I * &nu.slice(s![1, .., .., ..])).view(),
                            (-I * &k.slice(s![0, .., .., ..])).view(),
                        ],
                    )
                    .unwrap();

                    // row3 : [2kνμ, -(kb^2-2k^2)μ, 2kνμ, (kb^2-2k^2)μ]
                    let tmp23_row3 = concatenate(
                        Axis(2),
                        &[
                            ((num::complex::Complex::new(2.0 * mu_vec.get(2).unwrap(), 0.0)
                                * &k
                                * &nu)
                                .slice(s![2, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(-1.0 * mu_vec.get(2).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![2, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &k
                                * &nu)
                                .slice(s![1, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(1.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![1, .., .., ..]))
                                .view(),
                        ],
                    )
                    .unwrap();

                    // row4 : [(kb^2-2k^2)μ, 2kγμ, -(kb^2-2k^2)μ, 2kγμ]
                    let tmp23_row4 = concatenate(
                        Axis(2),
                        &[
                            (num::complex::Complex::new(1.0 * mu_vec.get(2).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![2, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(2).unwrap(), 0.0)
                                * &k
                                * &gm)
                                .slice(s![2, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(-1.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![1, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &k
                                * &gm)
                                .slice(s![1, .., .., ..]))
                            .view(),
                        ],
                    )
                    .unwrap();
                    // ---------------------------------------------------------------------------------------------------------------

                    // row1 : [ik, -iγ, -ik, -iγ]
                    let tmpr23_row1 = concatenate(
                        Axis(2),
                        &[
                            (I * &k.slice(s![0, .., .., ..])).view(),
                            (-I * &gm.slice(s![1, .., .., ..])).view(),
                            (-I * &k.slice(s![0, .., .., ..])).view(),
                            (-I * &gm.slice(s![2, .., .., ..])).view(),
                        ],
                    )
                    .unwrap();

                    // row2 : [iν, ik, iν, -ik]
                    let tmpr23_row2 = concatenate(
                        Axis(2),
                        &[
                            (I * &nu.slice(s![1, .., .., ..])).view(),
                            (I * &k.slice(s![0, .., .., ..])).view(),
                            (I * &nu.slice(s![2, .., .., ..])).view(),
                            (-I * &k.slice(s![0, .., .., ..])).view(),
                        ],
                    )
                    .unwrap();

                    // row3 : [2kνμ, -(kb^2-2k^2)μ, 2kνμ, (kb^2-2k^2)μ]
                    let tmpr23_row3 = concatenate(
                        Axis(2),
                        &[
                            ((num::complex::Complex::new(2.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &k
                                * &nu)
                                .slice(s![1, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(-1.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![1, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(2).unwrap(), 0.0)
                                * &k
                                * &nu)
                                .slice(s![2, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(1.0 * mu_vec.get(2).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![2, .., .., ..]))
                                .view(),
                        ],
                    )
                    .unwrap();

                    // row4 : [(kb^2-2k^2)μ, 2kγμ, -(kb^2-2k^2)μ, 2kγμ]
                    let tmpr23_row4 = concatenate(
                        Axis(2),
                        &[
                            (num::complex::Complex::new(1.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![1, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(1).unwrap(), 0.0)
                                * &k
                                * &gm)
                                .slice(s![1, .., .., ..]))
                            .view(),
                            (num::complex::Complex::new(-1.0 * mu_vec.get(2).unwrap(), 0.0)
                                * &kb2m2k2.slice(s![2, .., .., ..]))
                                .view(),
                            ((num::complex::Complex::new(2.0 * mu_vec.get(2).unwrap(), 0.0)
                                * &k
                                * &gm)
                                .slice(s![2, .., .., ..]))
                            .view(),
                        ],
                    )
                    .unwrap();

                    // end of upper layers - first part

                    tmp23 = Some(stack![
                        Axis(2),
                        tmp23_row1,
                        tmp23_row2,
                        tmp23_row3,
                        tmp23_row4
                    ]);
                    tmpr23 = Some(stack![
                        Axis(2),
                        tmpr23_row1,
                        tmpr23_row2,
                        tmpr23_row3,
                        tmpr23_row4
                    ]);
                }

                //okay
                let mut slayer = ndarray::Array4::<c64>::zeros((kx_vec.len(), ky_vec.len(), 2, 2));
                let mut slayerh = ndarray::Array4::<c64>::zeros((kx_vec.len(), ky_vec.len(), 1, 1));

                (0..kx_vec.len()).for_each(|ii| {
                    let mut tmp122 = None;
                    let mut tmp232 = None;
                    if nm > 1 {
                        let mut tmp12 = tmp12.as_mut().unwrap();

                        tmp122 = Some(tmp12.index_axis_mut(Axis(0), ii));
                    }
                    if nm > 2 {
                        let mut tmp23 = tmp23.as_mut().unwrap();
                        tmp232 = Some(tmp23.index_axis_mut(Axis(0), ii));
                    }
                    (0..ky_vec.len()).for_each(|jj| {
                        // let mut nal_1to2c = None;
                        let mut nal_1to2_invc = None;
                        let mut nal_1to2_rc = None;

                        if nm > 1 {
                            let mut tmpr12 = tmpr12.as_mut().unwrap();
                            let mut mat_1to2 = tmp122.as_mut().unwrap().index_axis_mut(Axis(0), jj);
                            let mat_1to2_r: ArrayView<_, Ix2> = tmpr12.slice(s![ii, jj, .., ..]);

                            // 1,2
                            let mut nal_1to2 = Matrix4::<c64>::new(
                                mat_1to2[(0, 0)],
                                mat_1to2[(0, 1)],
                                mat_1to2[(0, 2)],
                                mat_1to2[(0, 3)],
                                mat_1to2[(1, 0)],
                                mat_1to2[(1, 1)],
                                mat_1to2[(1, 2)],
                                mat_1to2[(1, 3)],
                                mat_1to2[(2, 0)],
                                mat_1to2[(2, 1)],
                                mat_1to2[(2, 2)],
                                mat_1to2[(2, 3)],
                                mat_1to2[(3, 0)],
                                mat_1to2[(3, 1)],
                                mat_1to2[(3, 2)],
                                mat_1to2[(3, 3)],
                            );

                            let mut nal_1to2_r = Matrix4::<c64>::new(
                                mat_1to2_r[(0, 0)],
                                mat_1to2_r[(0, 1)],
                                mat_1to2_r[(0, 2)],
                                mat_1to2_r[(0, 3)],
                                mat_1to2_r[(1, 0)],
                                mat_1to2_r[(1, 1)],
                                mat_1to2_r[(1, 2)],
                                mat_1to2_r[(1, 3)],
                                mat_1to2_r[(2, 0)],
                                mat_1to2_r[(2, 1)],
                                mat_1to2_r[(2, 2)],
                                mat_1to2_r[(2, 3)],
                                mat_1to2_r[(3, 0)],
                                mat_1to2_r[(3, 1)],
                                mat_1to2_r[(3, 2)],
                                mat_1to2_r[(3, 3)],
                            );

                            let mut nal_1to2_inv = Matrix4::<c64>::zeros();
                            na::linalg::try_invert_to(nal_1to2, &mut nal_1to2_inv);
                            // nal_1to2c = Some(nal_1to2.clone());
                            nal_1to2_invc = Some(nal_1to2_inv.clone());
                            nal_1to2_rc = Some(nal_1to2_r.clone());
                        }

                        // 2,3
                        // let mut nal_2to3c = None;
                        let mut nal_2to3_invc = None;
                        let mut nal_2to3_rc = None;
                        if nm > 2 {
                            let mut tmpr23 = tmpr23.as_mut().unwrap();
                            let mut mat_2to3 = tmp232.as_mut().unwrap().index_axis_mut(Axis(0), jj);
                            let mat_2to3_r: ArrayView<_, Ix2> = tmpr23.slice(s![ii, jj, .., ..]);

                            // let mut tmpr12 = tmpr12.as_mut().unwrap();
                            // let mut mat_1to2 = tmp122.as_mut().unwrap().index_axis_mut(Axis(0), jj);
                            // let mat_1to2_r: ArrayView<_, Ix2> = tmpr12.slice(s![ii, jj, .., ..]);

                            let mut nal_2to3 = Matrix4::<c64>::new(
                                mat_2to3[(0, 0)],
                                mat_2to3[(0, 1)],
                                mat_2to3[(0, 2)],
                                mat_2to3[(0, 3)],
                                mat_2to3[(1, 0)],
                                mat_2to3[(1, 1)],
                                mat_2to3[(1, 2)],
                                mat_2to3[(1, 3)],
                                mat_2to3[(2, 0)],
                                mat_2to3[(2, 1)],
                                mat_2to3[(2, 2)],
                                mat_2to3[(2, 3)],
                                mat_2to3[(3, 0)],
                                mat_2to3[(3, 1)],
                                mat_2to3[(3, 2)],
                                mat_2to3[(3, 3)],
                            );

                            let mut nal_2to3_r = Matrix4::<c64>::new(
                                mat_2to3_r[(0, 0)],
                                mat_2to3_r[(0, 1)],
                                mat_2to3_r[(0, 2)],
                                mat_2to3_r[(0, 3)],
                                mat_2to3_r[(1, 0)],
                                mat_2to3_r[(1, 1)],
                                mat_2to3_r[(1, 2)],
                                mat_2to3_r[(1, 3)],
                                mat_2to3_r[(2, 0)],
                                mat_2to3_r[(2, 1)],
                                mat_2to3_r[(2, 2)],
                                mat_2to3_r[(2, 3)],
                                mat_2to3_r[(3, 0)],
                                mat_2to3_r[(3, 1)],
                                mat_2to3_r[(3, 2)],
                                mat_2to3_r[(3, 3)],
                            );

                            let mut nal_2to3_inv = Matrix4::<c64>::zeros();
                            na::linalg::try_invert_to(nal_2to3, &mut nal_2to3_inv);
                            // nal_2to3c = Some(nal_2to3.clone());
                            nal_2to3_invc = Some(nal_2to3_inv.clone());
                            nal_2to3_rc = Some(nal_2to3_r.clone());
                        }

                        // ---

                        let z1 = med3_vec[0]; // it is okay
                        let mut z2 = C0;
                        if nm == 3 {
                            z2 = med3_vec[1] + med3_vec[0];
                        } else if nm == 2 {
                            z2 = z1;
                        }
                        // let z2_m_z1 = med3_vec[1];
                        let z2_m_z1 = z2 - z1;

                        // first layer - optional
                        let mut e1_z1_gm = None;
                        let mut e1_z1 = None;
                        let mut e1_mz1 = None;
                        if nm > 1 {
                            let e1_z1_nu = (I * &nu.slice(s![0, ii, jj, 0]).sum() * z1).exp();
                            e1_z1_gm = Some((I * &gm.slice(s![0, ii, jj, 0]).sum() * z1).exp());
                            e1_z1 = Some(Matrix2::<c64>::new(e1_z1_nu, C0, C0, e1_z1_gm.unwrap()));
                            e1_mz1 = Some(Matrix2::<c64>::new(
                                1.0 / e1_z1_nu,
                                C0,
                                C0,
                                1.0 / e1_z1_gm.unwrap(),
                            ));
                        }

                        // second layer - optional
                        let mut e2_z1 = None;
                        // let mut e2_mz1 = None;
                        let mut e2_z2 = None;
                        let mut e2_mz2 = None;
                        let mut e2_mz2_m_z1 = None;
                        let mut e2_z2_nu = None;
                        let mut e2_z2_gm = None;
                        let mut e2_z1_gm = None;
                        if nm > 1 {
                            let e2_z1_nu = (I * &nu.slice(s![nm - 2, ii, jj, 0]).sum() * z1).exp();
                            e2_z1_gm =
                                Some((I * &gm.slice(s![nm - 2, ii, jj, 0]).sum() * z1).exp());
                            e2_z2_nu =
                                Some((I * &nu.slice(s![nm - 2, ii, jj, 0]).sum() * z2).exp());
                            e2_z2_gm =
                                Some((I * &gm.slice(s![nm - 2, ii, jj, 0]).sum() * z2).exp());
                            let e2_z2_m_z1_nu =
                                (I * &nu.slice(s![nm - 2, ii, jj, 0]).sum() * z2_m_z1).exp();
                            let e2_z2_m_z1_gm =
                                (I * &gm.slice(s![nm - 2, ii, jj, 0]).sum() * z2_m_z1).exp();

                            e2_z1 = Some(Matrix2::<c64>::new(e2_z1_nu, C0, C0, e2_z1_gm.unwrap()));
                            // e2_mz1 = Some(Matrix2::<c64>::new(
                            //     1.0 / e2_z1_nu,
                            //     C0,
                            //     C0,
                            //     1.0 / e2_z1_gm.unwrap(),
                            // ));

                            e2_z2 = Some(Matrix2::<c64>::new(
                                e2_z2_nu.unwrap(),
                                C0,
                                C0,
                                e2_z2_gm.unwrap(),
                            ));
                            e2_mz2_m_z1 = Some(Matrix2::<c64>::new(
                                1.0 / e2_z2_m_z1_nu,
                                C0,
                                C0,
                                1.0 / e2_z2_m_z1_gm,
                            ));
                            e2_mz2 = Some(Matrix2::<c64>::new(
                                1.0 / e2_z2_nu.unwrap(),
                                C0,
                                C0,
                                1.0 / e2_z2_gm.unwrap(),
                            ));
                        }

                        // half-space - mandatory
                        let e3_z2_nu = (I * &nu.slice(s![nm - 1, ii, jj, 0]).sum() * z2).exp();
                        let e3_z2_gm = (I * &gm.slice(s![nm - 1, ii, jj, 0]).sum() * z2).exp();

                        let e3_z2 = Matrix2::<c64>::new(e3_z2_nu, C0, C0, e3_z2_gm);
                        // let e3_mz2 = Matrix2::<c64>::new(1.0 / e3_z2_nu, C0, C0, 1.0 / e3_z2_gm);

                        // not always

                        let mut td_1 = None;
                        let mut rd_1 = None;
                        let mut tu_1 = None;
                        let mut ru_1 = None;

                        if nm > 1 {
                            let nal_1to2_fin = nal_1to2_invc.unwrap() * nal_1to2_rc.unwrap();

                            td_1 = Some(nal_1to2_fin.slice((0, 0), (2, 2)) * C1 * e1_mz1.unwrap());
                            rd_1 = Some(nal_1to2_fin.slice((2, 0), (2, 2)) * C1 * e1_mz1.unwrap());
                            tu_1 = Some(nal_1to2_fin.slice((2, 2), (2, 2)) * C1);
                            ru_1 = Some(nal_1to2_fin.slice((0, 2), (2, 2)) * C1);
                        }

                        // let mut td_2 = None;
                        let mut rd_2 = None;
                        let mut tu_2 = None;
                        // let mut ru_2 = None;

                        if nm > 2 {
                            let nal_2to3_fin = nal_2to3_invc.unwrap() * nal_2to3_rc.unwrap();

                            // td_2 = Some(
                            //     nal_2to3_fin.slice((0, 0), (2, 2)) * C1 * e2_mz2_m_z1.unwrap(),
                            // );
                            rd_2 = Some(
                                nal_2to3_fin.slice((2, 0), (2, 2)) * C1 * e2_mz2_m_z1.unwrap(),
                            );
                            tu_2 = Some(nal_2to3_fin.slice((2, 2), (2, 2)) * C1);
                            // ru_2 = Some(nal_2to3_fin.slice((0, 2), (2, 2)) * C1);
                        }

                        let mut mu_1 = num::complex::Complex::new(1.0, 0.0);
                        let mut mu_2 = num::complex::Complex::new(1.0, 0.0);
                        let mut mu_3 = num::complex::Complex::new(1.0, 0.0);

                        if nm == 1 {
                            mu_1 = num::complex::Complex::new(1.0 * mu_vec.get(0).unwrap(), 0.0);
                        } else if nm == 2 {
                            mu_1 = num::complex::Complex::new(1.0 * mu_vec.get(0).unwrap(), 0.0);
                            mu_2 = num::complex::Complex::new(1.0 * mu_vec.get(1).unwrap(), 0.0);
                        } else if nm == 3 {
                            mu_1 = num::complex::Complex::new(1.0 * mu_vec.get(0).unwrap(), 0.0);
                            mu_2 = num::complex::Complex::new(1.0 * mu_vec.get(1).unwrap(), 0.0);
                            mu_3 = num::complex::Complex::new(1.0 * mu_vec.get(2).unwrap(), 0.0);
                        }

                        let mut rhd_1 = None;
                        let mut rhu_1 = None;
                        let mut thu_1 = None;
                        let mut thd_1 = None;
                        if nm > 1 {
                            rhd_1 = Some(
                                (-mu_2 * &gm.slice(s![1, ii, jj, 0])
                                    + mu_1 * &gm.slice(s![0, ii, jj, 0]))
                                    / (mu_1 * &gm.slice(s![0, ii, jj, 0])
                                        + mu_2 * &gm.slice(s![1, ii, jj, 0])),
                            );
                            rhu_1 = Some(
                                (-mu_1 * &gm.slice(s![0, ii, jj, 0])
                                    + mu_2 * &gm.slice(s![1, ii, jj, 0]))
                                    / (mu_1 * &gm.slice(s![0, ii, jj, 0])
                                        + mu_2 * &gm.slice(s![1, ii, jj, 0])),
                            );
                            thu_1 = Some(
                                (2.0 * mu_2 * &gm.slice(s![1, ii, jj, 0]))
                                    / (mu_1 * &gm.slice(s![0, ii, jj, 0])
                                        + mu_2 * &gm.slice(s![1, ii, jj, 0])),
                            );
                            thd_1 = Some(
                                (2.0 * mu_1 * &gm.slice(s![0, ii, jj, 0]))
                                    / (mu_1 * &gm.slice(s![0, ii, jj, 0])
                                        + mu_2 * &gm.slice(s![1, ii, jj, 0])),
                            );
                        }

                        let mut rhd_2 = None;
                        // let mut rhu_2 = None;
                        let mut thu_2 = None;
                        // let mut thd_2 = None;
                        if nm > 2 {
                            rhd_2 = Some(
                                (-mu_3 * &gm.slice(s![2, ii, jj, 0])
                                    + mu_2 * &gm.slice(s![1, ii, jj, 0]))
                                    / (mu_2 * &gm.slice(s![1, ii, jj, 0])
                                        + mu_3 * &gm.slice(s![2, ii, jj, 0])),
                            );
                            // rhu_2 = Some(
                            //     (-mu_2 * &gm.slice(s![1, ii, jj, 0])
                            //         + mu_3 * &gm.slice(s![2, ii, jj, 0]))
                            //         / (mu_2 * &gm.slice(s![1, ii, jj, 0])
                            //             + mu_3 * &gm.slice(s![2, ii, jj, 0])),
                            // );
                            thu_2 = Some(
                                (2.0 * mu_3 * &gm.slice(s![2, ii, jj, 0]))
                                    / (mu_2 * &gm.slice(s![1, ii, jj, 0])
                                        + mu_3 * &gm.slice(s![2, ii, jj, 0])),
                            );
                            // thd_2 = Some(
                            //     (2.0 * mu_2 * &gm.slice(s![1, ii, jj, 0]))
                            //         / (mu_2 * &gm.slice(s![1, ii, jj, 0])
                            //             + mu_3 * &gm.slice(s![2, ii, jj, 0])),
                            // );
                        }

                        // free surface
                        let det = det_gm.slice(s![0, ii, jj, 0]).sum();
                        let ru0_00 = -g11.slice(s![0, ii, jj, 0]).sum() / det;
                        let ru0_01 = -g12.slice(s![0, ii, jj, 0]).sum() / det;
                        let ru0_10 = -g21.slice(s![0, ii, jj, 0]).sum() / det;

                        // Ru0 - free surface
                        let ru0 = Matrix2::<c64>::new(ru0_00, ru0_01, ru0_10, ru0_00);
                        let ruh0 = 1.0;

                        let id = Matrix2::<c64>::identity();

                        // 2 to 1
                        let mut g_2_to_1 = None;
                        if nm > 1 {
                            let f12 = id * e1_z1.unwrap() - rd_1.unwrap() * ru0 * e1_mz1.unwrap();
                            let mut f12_inv = Matrix2::<c64>::zeros();
                            na::linalg::try_invert_to(f12, &mut f12_inv);
                            g_2_to_1 = Some(f12_inv * tu_1.unwrap() * e2_z1.unwrap());
                        }

                        // 3 to 2
                        let mut g_3_to_2 = None;
                        if nm == 3 {
                            let m_2 = td_1.unwrap()
                                * ru0
                                * e1_mz1.unwrap()
                                * e2_z1.unwrap()
                                * g_2_to_1.unwrap()
                                + ru_1.unwrap() * e2_z1.unwrap() * e2_z1.unwrap();
                            let f23 = id * e2_z2.unwrap() - rd_2.unwrap() * m_2 * e2_mz2.unwrap();
                            let mut f23_inv = Matrix2::<c64>::zeros();
                            na::linalg::try_invert_to(f23, &mut f23_inv);
                            g_3_to_2 = Some(f23_inv * tu_2.unwrap() * e3_z2);
                        }

                        // 2 to 1
                        let mut gh_2_to_1 = None;
                        if nm > 1 {
                            gh_2_to_1 = Some(
                                C1 / (e1_z1_gm.unwrap()
                                    - rhd_1.unwrap() * ruh0 / e1_z1_gm.unwrap())
                                    * thu_1.unwrap()
                                    * e2_z1_gm.unwrap(),
                            );
                        }

                        // 3 to 2
                        let mut gh_3_to_2 = None;
                        if nm == 3 {
                            let gh2to1 = gh_2_to_1.clone();
                            let mh_2 = thd_1.unwrap() * ruh0 / e1_z1_gm.unwrap()
                                * e2_z1_gm.unwrap()
                                * gh2to1.unwrap()
                                + rhu_1.unwrap() * e2_z1_gm.unwrap() * e2_z1_gm.unwrap();
                            gh_3_to_2 = Some(
                                C1 / (e2_z2_gm.unwrap()
                                    - rhd_2.unwrap() * mh_2 / e2_z2_gm.unwrap())
                                    * thu_2.unwrap()
                                    * e3_z2_gm,
                            );
                        }

                        // for the top layer

                        let dp = Matrix2::<c64>::new(
                            -I * k.slice(s![0, ii, jj, 0]).sum(),
                            -I * gm.slice(s![0, ii, jj, 0]).sum(),
                            I * nu.slice(s![0, ii, jj, 0]).sum(),
                            -I * k.slice(s![0, ii, jj, 0]).sum(),
                        );
                        let dm = Matrix2::<c64>::new(
                            -I * k.slice(s![0, ii, jj, 0]).sum(),
                            I * gm.slice(s![0, ii, jj, 0]).sum(),
                            -I * nu.slice(s![0, ii, jj, 0]).sum(),
                            -I * k.slice(s![0, ii, jj, 0]).sum(),
                        );

                        let gg = dm * ru0 + dp;

                        // the simple case of nm == 1
                        let mut q = gg;
                        let mut q_sh = 2.0 * C1;

                        if nm == 3 {
                            q = q * g_2_to_1.unwrap() * g_3_to_2.unwrap();
                            q_sh = q_sh * gh_2_to_1.unwrap().sum() * gh_3_to_2.unwrap().sum();
                        } else if nm == 2 {
                            q = q * g_2_to_1.unwrap();
                            q_sh = q_sh * gh_2_to_1.unwrap().sum();
                        }

                        // nalgebra to ndarray

                        slayer[(ii, jj, 0, 0)] = q[(0, 0)].to_owned();
                        slayer[(ii, jj, 0, 1)] = q[(0, 1)].to_owned();
                        slayer[(ii, jj, 1, 0)] = q[(1, 0)].to_owned();
                        slayer[(ii, jj, 1, 1)] = q[(1, 1)].to_owned();
                        slayerh[(ii, jj, 0, 0)] = q_sh.to_owned();
                    });
                });

                // #######################################

                // let r_u_0 = 0.0;

                let rr00 = slayer
                    .slice(s![.., .., 0, 0])
                    .insert_axis(Axis(0))
                    .insert_axis(Axis(3));
                let rr01 = slayer
                    .slice(s![.., .., 0, 1])
                    .insert_axis(Axis(0))
                    .insert_axis(Axis(3));
                let rr10 = slayer
                    .slice(s![.., .., 1, 0])
                    .insert_axis(Axis(0))
                    .insert_axis(Axis(3));
                let rr11 = slayer
                    .slice(s![.., .., 1, 1])
                    .insert_axis(Axis(0))
                    .insert_axis(Axis(3));
                let rrsh = slayerh
                    .slice(s![.., .., 0, 0])
                    .insert_axis(Axis(0))
                    .insert_axis(Axis(3));

                // calculate only for the last medium
                let gm2 = gm2.slice(s![nm - 1, .., .., ..]).insert_axis(Axis(0));
                let gm = gm.slice(s![nm - 1, .., .., ..]).insert_axis(Axis(0));
                // let nu2 = nu2.slice(s![nm - 1, .., .., ..]).insert_axis(Axis(0));
                let nu = nu.slice(s![nm - 1, .., .., ..]).insert_axis(Axis(0));
                let a_const = a_const.slice(s![nm - 1, .., .., ..]).insert_axis(Axis(0));

                // c_phi
                let c_phi = (-0.5 + 0.0 * I)
                    * ((cmat[0][0] * &kx2 + cmat[1][1] * &ky2 + 2.0 * cmat[0][1] * &kx_ky) / &nu
                        - 2.0 * cmat[0][2] * &kx_arr
                        - 2.0 * cmat[1][2] * &ky_arr
                        + cmat[2][2] * &nu);

                // c_psi_sv
                let c_psi_sv = -((cmat[0][0] - cmat[2][2]) * &kx2
                    + (cmat[1][1] - cmat[2][2]) * &ky2
                    + (cmat[0][2] * &kx_arr + cmat[1][2] * &ky_arr) * (&k2 - &gm2) / &gm
                    + 2.0 * cmat[0][1] * &kx_ky)
                    / &k;

                // c_psi_sh
                let c_psi_sh = -((cmat[0][0] - cmat[1][1]) * &kx_ky - cmat[0][1] * (&kx2 - &ky2)
                    + (cmat[1][2] * &kx_arr - cmat[0][2] * &ky_arr) * &gm)
                    * (&gm2 + &k2)
                    / (&gm * &k);

                let kern_phi = I * &a_const * &c_phi * &rr00;
                let kern_psi_sv = 0.5 * I * &a_const * &c_psi_sv * &rr01;
                let kern_psi_sh = 0.5 * C1 * &a_const * &c_psi_sh * &rrsh;

                let kern_phi_x_arr = &kern_phi * &kx_arr / &k;
                let kern_phi_y_arr = &kern_phi * &ky_arr / &k;
                let kern_psi_sv_x_arr = &kern_psi_sv * &kx_arr / &k;
                let kern_psi_sv_y_arr = &kern_psi_sv * &ky_arr / &k;
                let kern_psi_sh_x_arr = &kern_psi_sh * &ky_arr / &k;
                let kern_psi_sh_y_arr = -&kern_psi_sh * &kx_arr / &k;
                let kern_phi_z_arr = I * &a_const * &c_phi * &rr10;
                let kern_psi_sv_z_arr = 0.5 * I * &a_const * &c_psi_sv * &rr11;

                (
                    ukey,
                    (
                        kx_arr.to_owned(), // krl[&ukey].0
                        ky_arr.to_owned(), // krl[&ukey].1
                        nu.to_owned(),     // krl[&ukey].2
                        gm.to_owned(),     // krl[&ukey].3
                        kern_phi_x_arr,    // krl[&ukey].4
                        kern_phi_y_arr,    // krl[&ukey].5
                        kern_psi_sv_x_arr, // krl[&ukey].6
                        kern_psi_sv_y_arr, // krl[&ukey].7
                        kern_psi_sh_x_arr, // krl[&ukey].8
                        kern_psi_sh_y_arr, // krl[&ukey].9
                        kern_phi_z_arr,    // krl[&ukey].10
                        kern_psi_sv_z_arr, // krl[&ukey].11
                    ),
                )
            })
            .collect();
        // I matrices

        // let toc_init = tic_init.elapsed();
        // println!("time elapsed [initialization] : {:?}",toc_init);
        Fault {
            // dims,
            angles,
            loc,
            fpars,
            medium,
            conf,
            krl,
            w,
            w2,
        }
    }

    pub fn simulate(
        &self,
        sloc: Vec<((f64, f64, f64, f64, f64, f64), Vec<(f64, f64)>)>,
        recloc: Vec<(f64, f64)>,
        n_samples: usize,
    ) -> (
        Vec<Vec<f64>>,
        Vec<Vec<f64>>,
        Vec<Vec<f64>>,
        Vec<Vec<f64>>,
        Vec<Vec<f64>>,
        Vec<Vec<f64>>,
        Vec<Vec<f64>>,
        Vec<Vec<f64>>,
        Vec<Vec<f64>>,
    ) {
        // let tic_gen = Instant::now();
        let tmat90 = tmatn_create(self.angles.0, self.angles.1);
        let x_vec = recloc.par_iter().map(|r| r.0).collect::<Vec<_>>();
        let y_vec = recloc.par_iter().map(|r| r.1).collect::<Vec<_>>();
        let x_arr = ArrayView::from_shape((1, 1, x_vec.len()), &x_vec).unwrap();
        let y_arr = ArrayView::from_shape((1, 1, y_vec.len()), &y_vec).unwrap();

        let mut x_disp = Array2::<c64>::zeros((self.krl.keys().len(), x_vec.len()));
        // let mut y_disp = Array2::<c64>::zeros((self.krl.keys().len(), x_vec.len()));
        // let mut z_disp = Array2::<c64>::zeros((self.krl.keys().len(), x_vec.len()));

        let mut disp: std::collections::HashMap<usize, (Array1<c64>, Array1<c64>, Array1<c64>)> =
            (0..self.krl.keys().len())
                .into_par_iter()
                .map(|ukey| {
                    let mut exy = &self.krl[&ukey].0.slice(s![0, .., .., ..]) * &x_arr * (-I)
                        + &self.krl[&ukey].1.slice(s![0, .., .., ..]) * &y_arr * (-I);
                    exy.par_mapv_inplace(c64::exp);

                    let mut eu = sloc
                        .par_iter()
                        .map(|srs| {
                            let locx =
                                self.loc.0 + srs.0 .2 * tmat90[0][0] + srs.0 .3 * tmat90[0][1]
                                    - tmat90[0][1] * srs.0 .1 / 2.0;
                            let locy =
                                self.loc.1 + srs.0 .2 * tmat90[1][0] + srs.0 .3 * tmat90[1][1]
                                    - tmat90[1][1] * srs.0 .1 / 2.0;
                            let locz =
                                self.loc.2 + srs.0 .2 * tmat90[2][0] + srs.0 .3 * tmat90[2][1]
                                    - tmat90[2][1] * srs.0 .1 / 2.0;

                            let mut kc_ukey = 0.0 * I;

                            // println!("vel = {}", srs.0.2);
                            // println!("angl = {}", srs.0.3);

                            if srs.0 .4 != 0.0 {
                                kc_ukey = self.w[ukey] / srs.0 .4;
                            }

                            let cth1 = f64::cos(srs.0 .5);
                            let sth1 = f64::sin(srs.0 .5);

                            let mut i_c = num::complex::Complex::new(1.0, 0.0);

                            let mut sgnl = num::complex::Complex::new(1.0, 0.0);
                            let mut sgnw = num::complex::Complex::new(1.0, 0.0);

                            if (srs.0 .5 >= PI / 2.0) && (srs.0 .5 <= 3.0 * PI / 2.0) {
                                i_c *= c64::exp(kc_ukey * I * srs.0 .0 * cth1);
                                sgnl *= 1.0;
                                sgnw *= 1.0;
                            }

                            if (srs.0 .5 > PI) && (srs.0 .5 <= 2.0 * PI) {
                                i_c *= c64::exp(kc_ukey * I * srs.0 .1 * sth1);
                            }

                            let c_l_nu = I
                                * srs.0 .0
                                * (-kc_ukey * cth1 * sgnl
                                    + tmat90[0][0] * &self.krl[&ukey].0
                                    + tmat90[1][0] * &self.krl[&ukey].1
                                    - tmat90[2][0] * &self.krl[&ukey].2);
                            let il_nu = (c_l_nu.mapv(c64::exp) - 1.0) / c_l_nu * srs.0 .0;

                            let c_l_gm = I
                                * srs.0 .0
                                * (-kc_ukey * cth1 * sgnl
                                    + tmat90[0][0] * &self.krl[&ukey].0
                                    + tmat90[1][0] * &self.krl[&ukey].1
                                    - tmat90[2][0] * &self.krl[&ukey].3);
                            let il_gm = (c_l_gm.mapv(c64::exp) - 1.0) / c_l_gm * srs.0 .0;

                            let c_w_nu = I
                                * srs.0 .1
                                * (-kc_ukey * sth1 * sgnw
                                    + tmat90[0][1] * &self.krl[&ukey].0
                                    + tmat90[1][1] * &self.krl[&ukey].1
                                    - tmat90[2][1] * &self.krl[&ukey].2);
                            let iw_nu = i_c * (c_w_nu.mapv(c64::exp) - 1.0) / c_w_nu * srs.0 .1;

                            let c_w_gm = I
                                * srs.0 .1
                                * (-kc_ukey * sth1 * sgnw
                                    + tmat90[0][1] * &self.krl[&ukey].0
                                    + tmat90[1][1] * &self.krl[&ukey].1
                                    - tmat90[2][1] * &self.krl[&ukey].3);
                            let iw_gm = i_c * (c_w_gm.mapv(c64::exp) - 1.0) / c_w_gm * srs.0 .1;

                            let ex0y0z0_nu =
                                (&self.krl[&ukey].0.slice(s![0, .., .., ..]) * locx * I
                                    + &self.krl[&ukey].1.slice(s![0, .., .., ..]) * locy * I
                                    - &self.krl[&ukey].2.slice(s![0, .., .., ..]) * locz * I)
                                    .mapv(c64::exp); // 1
                            let ex0y0z0_gm =
                                (&self.krl[&ukey].0.slice(s![0, .., .., ..]) * locx * I
                                    + &self.krl[&ukey].1.slice(s![0, .., .., ..]) * locy * I
                                    - &self.krl[&ukey].3.slice(s![0, .., .., ..]) * locz * I)
                                    .mapv(c64::exp); // 1

                            let mut sf = 0.0 * I;

                            for si in 1..srs.1.len() {
                                sf += -(I * srs.1[si].1 / self.w[ukey]
                                    + (srs.1[si].1 - srs.1[si - 1].1)
                                        / (self.w2[ukey] * (srs.1[si].0 - srs.1[si - 1].0)))
                                    * c64::exp(-I * self.w[ukey] * srs.1[si].0)
                                    + (I * srs.1[si - 1].1 / self.w[ukey]
                                        + (srs.1[si].1 - srs.1[si - 1].1)
                                            / (self.w2[ukey] * (srs.1[si].0 - srs.1[si - 1].0)))
                                        * c64::exp(-I * self.w[ukey] * srs.1[si - 1].0);
                            }

                            sf += I
                                * srs.1[srs.1.len() - 1].1
                                * c64::exp(-I * self.w[ukey] * srs.1[srs.1.len() - 1].0)
                                / self.w[ukey];

                            (
                                &ex0y0z0_nu
                                    * sf
                                    * iw_nu.slice(s![0, .., .., ..])
                                    * il_nu.slice(s![0, .., .., ..]),
                                &ex0y0z0_gm
                                    * sf
                                    * iw_gm.slice(s![0, .., .., ..])
                                    * il_gm.slice(s![0, .., .., ..]),
                            ) // 1
                        })
                        .reduce(
                            || {
                                (
                                    Array3::<c64>::zeros((
                                        self.krl[&ukey].0.len(),
                                        self.krl[&ukey].1.len(),
                                        x_vec.len(),
                                    )),
                                    Array3::<c64>::zeros((
                                        self.krl[&ukey].0.len(),
                                        self.krl[&ukey].1.len(),
                                        x_vec.len(),
                                    )),
                                )
                            },
                            |x, y| (x.0 + y.0, x.1 + y.1),
                        );

                    let u00 = &exy
                        * (&self.krl[&ukey].4.slice(s![0, .., .., ..]) * &eu.0
                            + (&self.krl[&ukey].6.slice(s![0, .., .., ..])
                                + &self.krl[&ukey].8.slice(s![0, .., .., ..]))
                                * &eu.1); // 1
                    let u11 = &exy
                        * (&self.krl[&ukey].5.slice(s![0, .., .., ..]) * &eu.0
                            + (&self.krl[&ukey].7.slice(s![0, .., .., ..])
                                + &self.krl[&ukey].9.slice(s![0, .., .., ..]))
                                * &eu.1); // 1
                    let u22 = -&exy
                        * (&self.krl[&ukey].10.slice(s![0, .., .., ..]) * &eu.0
                            + &self.krl[&ukey].11.slice(s![0, .., .., ..]) * &eu.1); // 1

                    let u0 = &u00.sum_axis(Axis(0)).sum_axis(Axis(0));
                    let u2 = &u22.sum_axis(Axis(0)).sum_axis(Axis(0));
                    let u1 = &u11.sum_axis(Axis(0)).sum_axis(Axis(0));

                    // println!("-- u1 -- = {:?}", u1);
                    (ukey, (u0.clone(), u1.clone(), u2.clone()))
                })
                .collect();

        let mut planner = FftPlanner::new();
        let fft = planner.plan_fft_inverse(n_samples);
        let mut seis_x: Vec<Vec<f64>> = Vec::new();
        let mut seis_y: Vec<Vec<f64>> = Vec::new();
        let mut seis_z: Vec<Vec<f64>> = Vec::new();
        let mut vseis_x: Vec<Vec<f64>> = Vec::new();
        let mut vseis_y: Vec<Vec<f64>> = Vec::new();
        let mut vseis_z: Vec<Vec<f64>> = Vec::new();
        let mut aseis_x: Vec<Vec<f64>> = Vec::new();
        let mut aseis_y: Vec<Vec<f64>> = Vec::new();
        let mut aseis_z: Vec<Vec<f64>> = Vec::new();

        let mut ampl = f64::exp(self.conf.4 * PI / ((n_samples as f64) - 1.0)); // amplification factor

        for i in 0..x_disp.ncols() {
            let mut buf_x: Vec<c64> = Vec::<c64>::new();
            let mut buf_y: Vec<c64> = Vec::<c64>::new();
            let mut buf_z: Vec<c64> = Vec::<c64>::new();
            let mut vbuf_x: Vec<c64> = Vec::<c64>::new();
            let mut vbuf_y: Vec<c64> = Vec::<c64>::new();
            let mut vbuf_z: Vec<c64> = Vec::<c64>::new();
            let mut abuf_x: Vec<c64> = Vec::<c64>::new();
            let mut abuf_y: Vec<c64> = Vec::<c64>::new();
            let mut abuf_z: Vec<c64> = Vec::<c64>::new();

            // let buf_len_tmp = 2.0 * disp.keys().len() as f64;

            for it in 0..disp.keys().len() {
                buf_x.push(disp[&it].0[i]);
                buf_y.push(disp[&it].1[i]);
                buf_z.push(disp[&it].2[i]);
                vbuf_x.push(disp[&it].0[i] * I * (self.w[it].re)); //(buf_len_tmp *self.fpars.0));
                vbuf_y.push(disp[&it].1[i] * I * (self.w[it].re)); //(buf_len_tmp *self.fpars.0));
                vbuf_z.push(disp[&it].2[i] * I * (self.w[it].re)); //(buf_len_tmp *self.fpars.0));
                abuf_x.push(-disp[&it].0[i] * self.w[it].re * self.w[it].re); //((buf_len_tmp *self.fpars.0)*(buf_len_tmp *self.fpars.0)));
                abuf_y.push(-disp[&it].1[i] * self.w[it].re * self.w[it].re); //((buf_len_tmp *self.fpars.0)*(buf_len_tmp *self.fpars.0)));
                abuf_z.push(-disp[&it].2[i] * self.w[it].re * self.w[it].re); //((buf_len_tmp *self.fpars.0)*(buf_len_tmp *self.fpars.0)));
            }
            let mut cfx = 1.0 / ampl;
            let mut cfy = 1.0 / ampl;
            let mut cfz = 1.0 / ampl;
            let buf_len = buf_x.len() as f64;

            for _ in buf_x.len()..=n_samples / 2 {
                buf_x.push(I * 0.0);
                buf_y.push(I * 0.0);
                buf_z.push(I * 0.0);
                vbuf_x.push(I * 0.0);
                vbuf_y.push(I * 0.0);
                vbuf_z.push(I * 0.0);
                abuf_x.push(I * 0.0);
                abuf_y.push(I * 0.0);
                abuf_z.push(I * 0.0);
            }

            for j in (n_samples / 2 + 1)..n_samples {
                buf_x.push(num::complex::Complex::conj(&buf_x[n_samples - j]));
                buf_y.push(num::complex::Complex::conj(&buf_y[n_samples - j]));
                buf_z.push(num::complex::Complex::conj(&buf_z[n_samples - j]));
                vbuf_x.push(num::complex::Complex::conj(&vbuf_x[n_samples - j]));
                vbuf_y.push(num::complex::Complex::conj(&vbuf_y[n_samples - j]));
                vbuf_z.push(num::complex::Complex::conj(&vbuf_z[n_samples - j]));
                abuf_x.push(num::complex::Complex::conj(&abuf_x[n_samples - j]));
                abuf_y.push(num::complex::Complex::conj(&abuf_y[n_samples - j]));
                abuf_z.push(num::complex::Complex::conj(&abuf_z[n_samples - j]));
            }

            fft.process(&mut buf_x);
            fft.process(&mut buf_y);
            fft.process(&mut buf_z);
            fft.process(&mut vbuf_x);
            fft.process(&mut vbuf_y);
            fft.process(&mut vbuf_z);
            fft.process(&mut abuf_x);
            fft.process(&mut abuf_y);
            fft.process(&mut abuf_z);
            let out_x = buf_x[0].re;
            let out_y = buf_y[0].re;
            let out_z = buf_z[0].re;
            let vout_x = vbuf_x[0].re;
            let vout_y = vbuf_y[0].re;
            let vout_z = vbuf_z[0].re;
            let aout_x = abuf_x[0].re;
            let aout_y = abuf_y[0].re;
            let aout_z = abuf_z[0].re;
            seis_x.push(
                buf_x
                    .iter()
                    .map(|r| {
                        cfx *= ampl;
                        (r.re * cfx - out_x) / f64::sqrt(4.0 * buf_len)
                    })
                    .collect::<Vec<_>>(),
            );
            seis_y.push(
                buf_y
                    .iter()
                    .map(|r| {
                        cfy *= ampl;
                        (r.re * cfy - out_y) / f64::sqrt(4.0 * buf_len)
                    })
                    .collect::<Vec<_>>(),
            );
            seis_z.push(
                buf_z
                    .iter()
                    .map(|r| {
                        cfz *= ampl;
                        (r.re * cfz - out_z) / f64::sqrt(4.0 * buf_len)
                    })
                    .collect::<Vec<_>>(),
            );

            cfx = 1.0 / ampl;
            cfy = 1.0 / ampl;
            cfz = 1.0 / ampl;
            vseis_x.push(
                vbuf_x
                    .iter()
                    .map(|r| {
                        cfx *= ampl;
                        (r.re * cfx - vout_x) / f64::sqrt(4.0 * buf_len)
                    })
                    .collect::<Vec<_>>(),
            );
            vseis_y.push(
                vbuf_y
                    .iter()
                    .map(|r| {
                        cfy *= ampl;
                        (r.re * cfy - vout_y) / f64::sqrt(4.0 * buf_len)
                    })
                    .collect::<Vec<_>>(),
            );
            vseis_z.push(
                vbuf_z
                    .iter()
                    .map(|r| {
                        cfz *= ampl;
                        (r.re * cfz - vout_z) / f64::sqrt(4.0 * buf_len)
                    })
                    .collect::<Vec<_>>(),
            );
            cfx = 1.0 / ampl;
            cfy = 1.0 / ampl;
            cfz = 1.0 / ampl;
            aseis_x.push(
                abuf_x
                    .iter()
                    .map(|r| {
                        cfx *= ampl;
                        (r.re * cfx - aout_x) / f64::sqrt(4.0 * buf_len)
                    })
                    .collect::<Vec<_>>(),
            );
            aseis_y.push(
                abuf_y
                    .iter()
                    .map(|r| {
                        cfy *= ampl;
                        (r.re * cfy - aout_y) / f64::sqrt(4.0 * buf_len)
                    })
                    .collect::<Vec<_>>(),
            );
            aseis_z.push(
                abuf_z
                    .iter()
                    .map(|r| {
                        cfz *= ampl;
                        (r.re * cfz - aout_z) / f64::sqrt(4.0 * buf_len)
                    })
                    .collect::<Vec<_>>(),
            );
        }
        // let toc_gen = tic_gen.elapsed();
        // println!("time elapsed [simulation]: {:?}",toc_gen);
        (
            seis_x, seis_y, seis_z, vseis_x, vseis_y, vseis_z, aseis_x, aseis_y, aseis_z,
        )
    }
}

#[pymodule]
fn grmot(_: Python, module: &PyModule) -> PyResult<()> {
    module.add_class::<Fault>()?;
    Ok(())
}
