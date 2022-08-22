import numpy as np
import bisect
from pyproj import Proj
from scipy.signal import butter, lfilter, freqz

def emp_cc_r(mw):
    return 10**(-2.58+0.5*mw)/2

def emp_nf_l(mw):
    return 10**(-1.88+0.5*mw)

def emp_nf_a(mw):
    return 10**(-2.87+0.82*mw)

def m0_to_mw(m0): # Nm
    return 2.0/3.0*np.log10(m0*10**7)-10.7

def mw_to_m0(mw): 
    return 10**(1.5*(mw+10.7)-7.0)

def dsigma(m0,r): # Nm, km
    return 7.0*m0/(16.0*r**3*10**14)

def delay(signal, fs, dt):
    dt_star = int(dt)
    epsilon = dt-dt_star
    n = len(signal)
    t = np.linspace(0,(n-1)/fs,n)
    tmp_idx = bisect.bisect_left(t, dt)
    if tmp_idx > 0:
        if t[tmp_idx]-dt > dt - t[tmp_idx-1]:
            dt = t[tmp_idx-1]
        else:
            dt = t[tmp_idx]
    else:
        dt = t[tmp_idx]
    signal_fd = np.fft.fft(signal)
    w = 2*np.pi*fs*np.linspace(0,n-1,n)/n
    signal_fd *= np.exp(-1j*w*dt)
    signal_td = np.real(np.fft.ifft(signal_fd))
    signal_td[0:tmp_idx]=0.0
    return signal_td

def diff_signals(sig1,sig2,fs,dt=1.0,n=16):
    dls = np.linspace(0.0,dt/2.0,n//2)
    min_norm = 1e9
    for it in dls:
        sig1_tmp = delay(sig1,fs,it)
        tmp1_norm = np.linalg.norm(sig1_tmp-sig2)
        sig2_tmp = delay(sig2,fs,it)
        tmp2_norm = np.linalg.norm(sig2_tmp-sig1)
        tmp_norm = min(tmp1_norm,tmp2_norm)
        if tmp_norm < min_norm:
            min_norm = tmp_norm
    return min_norm

def amp(signal, d):
    n = len(signal)
    lkeys = list(d.keys())
    n2 = n//2
    fr = np.linspace(0,lkeys[-1],n2)
    pos = [0]
    c = 1
    for i in range(1,len(lkeys)):
        while fr[c] < lkeys[i]:
            c += 1
        pos.append(c+1)
    pos.append(n2)
    res = np.zeros((n,))
    for i in range(1,len(lkeys)):
        res[pos[i-1]:pos[i]+1]=np.linspace(d[lkeys[i-1]],d[lkeys[i]],pos[i]-pos[i-1]+1)
    for i in range(n2):
        res[i+n2] = res[n2-i]
    signal_fd = np.fft.fft(signal)
    signal_fd_amp = signal_fd * res
    signal_amp = np.real(np.fft.ifft(signal_fd_amp))
    return signal_amp

# L, W, dl, radius_xi, radius_eta, xi, eta, coef, delay, nxi, neta, vr, code  
def approx_elliptical_crack(crack_params):
    m0it = 0
    source_i = []
    L, W, dl, D1, D2, xi, et, K, dtm, nx, ny, vrt, code =  crack_params
    R = int(L/dl)
    C = int(W/dl)
    x = np.linspace(dl/2, L-dl/2, R)
    y = np.linspace(-W/2+dl/2, W/2-dl/2, C)
    x = np.expand_dims(x, axis = -1)
    y = np.expand_dims(y, axis = 0)
    vr = ((vrt**2 * D1**2 )/ ((D2 + np.abs(ny) * dl)**2 + (nx * dl)**2))**0.5
    vx = vr
    vy = D2/D1 * vx
    # th = np.pi * th/180
    tf = max(D1/vx, D2/vy)
    # print('rtx =', D1/vx)
    # print('rtx =', D2/vy)
    t = np.linspace(0,tf,1024)
    # ru = np.minimum(((x - xi)**2 + (y - et)**2)**0.5, D)
    ru = ((x - xi)**2 + (y - et)**2)**0.5
    cosp = (x - xi)/ru
    p = np.sign(y-et)*np.arccos(cosp)
    cosp = (np.cos(p))
    # d2 = (nuclp[0]-xi-nx*dl)**2 + (nuclp[1]-et-ny*dl)**2
    # tau = np.sqrt(d2)/rveln
    # print('------------------------------')
    # print('crack #', post_name, ': τ =', tau)
    # continue
    dist_nucl = np.zeros((R,C))
    theta0 = np.zeros((R,C))
    maxslip = np.zeros((R,C))
    ruptvel = np.zeros((R,C))
    resti = []
    restj = []
    cct = []
    for i in range(R):
        x_tmp = ((x[i,0] -xi-nx*(1-vx*t/D1))**2)/vx**2
        #print(x_tmp.shape)
        for j in range(C):
            if (x[i,0]-xi)**2/D1**2 + (y[0,j]-et)**2/D2**2 < 1:
                y_tmp = ((y[0,j]-et-ny*(1-vy*t/D2))**2)/vy**2
                htime = t**2 - x_tmp - y_tmp
                kk = 0
                while htime[kk] < 0:
                    kk+=1
                ct = np.linspace(t[kk], tf, 128) 
                dist_nucl[i,j] = np.sqrt((x[i,0] -xi - nx)**2 + (y[0,j]- et -ny)**2)
                # T[i,j] = t[kk] + dtm
                yy = ct**2 - ((x[i,0] -xi-nx*(1-vx*ct/D1))**2)/vx**2 - ((y[0,j]-et-ny*(1-vy*ct/D2))**2)/vy**2
                yy = K*np.nan_to_num(np.sqrt(yy))
                if i*dl >= nx + xi and j*dl + dl - W/2 <= ny + et:
                    tanth0 = 0
                    if ny + et !=  j*dl + dl - W/2:
                        tanth0 = (-nx-xi + i*dl)/(ny + et - j*dl - dl + W/2)
                        thp = np.arctan(tanth0)
                        th0 = 2*np.pi -(np.pi - np.arctan(tanth0))+np.pi/2
                    else:
                        th0 = 2*np.pi
                        thp = th0
                    # vr_idx[i,j] = (thp*vx + (np.pi/2 - thp)*vy)*2/np.pi
                    theta0[i,j] = th0
                elif i*dl >= nx + xi and j*dl - W/2 >= ny + et:
                    tanth0 = 0
                    if j*dl - W/2 !=  ny + et:
                        tanth0 = (-nx-xi + i*dl)/(-ny - et + j*dl + dl - W/2)
                        thp = np.arctan(tanth0)
                        th0 = np.pi/2 - np.arctan(tanth0)
                    else:
                        th0 = np.pi/2*0
                        thp = th0
                    theta0[i,j] = th0
                    # vr_idx[i,j] = (thp*vx + (np.pi/2 - thp)*vy)*2/np.pi
                elif i*dl +dl <= nx + xi and j*dl +dl - W/2 <= ny + et:
                    tanth0 = 0
                    if j*dl +dl - W/2 !=  ny + et:
                        tanth0 = (-i*dl - dl + nx + xi)/(-j*dl -dl + W/2 + ny + et)
                        thp = np.arctan(tanth0)
                        th0 = (np.pi + np.arctan(tanth0))
                    else:
                        th0 = np.pi + np.pi/2
                        thp = np.pi/2
                    # vr_idx[i,j] = (thp*vx + (np.pi/2 - thp)*vy)*2/np.pi
                    theta0[i,j] =  3*np.pi/2 - th0 + np.pi
                elif i*dl +dl <= nx + xi and j*dl - W/2 >= ny + et:
                    tanth0 = 0
                    if j*dl + dl - W/2 !=  ny + et:
                        tanth0 = (-i*dl - dl + nx + xi)/(j*dl +dl - W/2 - ny - et)
                        thp = np.arctan(tanth0)
                        th0 = 3*np.pi/2 + np.pi/2 - np.arctan(tanth0)
                    else:
                        th0 = 3*np.pi/2 - np.pi/2
                        thp = np.pi/2
                    # vr_idx[i,j] = (thp*vx + (np.pi/2 - thp)*vy)*2/np.pi
                    theta0[i,j] = 3*np.pi/2-(th0 - np.pi)
                else:
                    resti.append(i)
                    restj.append(j)
                    if i*dl < xi:
                        theta0[i,j] = np.pi
                    else:
                        theta0[i,j] = 0.0
                    # vr_idx[i,j] = (thp*vx + (np.pi/2 - thp)*vy)*2/np.pi
                tm = dtm
                ct += tm # 0.*((circ[0][1] - xi)**2 + 1*(circ[0][2] - et)**2)**0.5/vr
                dist_nucl[i,j]=dist_nucl[i,j]/(ct[0]-tm)
                # s0 = (dl, dl, x[i,0]-dl/2,y[0,j],dist_nucl[i,j],theta0[i,j])
                
                s1 = [(ct[0],yy[0]),(ct[3],yy[3]),(ct[7],yy[7]),(ct[15],yy[15]),(ct[31],yy[31]),(ct[63],yy[63]),(ct[127],yy[127])]

                maxslip[i,j] += yy[127]
                ruptvel[i,j] = dist_nucl[i,j]
                cct.append(s1)
                # P[i,j] += yy[127]
                # source_i.append((s0,s1))
                # sources_idx[(i,j)] = s1
                M0ij = 1.9 * 10**6 * dl**2 * yy[127] * 1600 * 3200**2
                m0it += M0ij
    repi = -1;
    repj = -1;
    for i in range(len(resti)-1):
        if resti[i]==resti[i+1]:
            repi = resti[i]
            break
    for j in range(len(restj)-1):
        if restj[j]==restj[j+1]:
            repj = restj[j]
            break
    # print('repi=',repi)
    # print('repj=',repj)
    if repi>0:
        for j in range(C):
            theta0[repi,j]=(theta0[repi-1,j]+theta0[repi+1,j])/2.0
    if repj>0:
        for i in range(R):
            theta0[i,repj]=(theta0[i,repj-1]+theta0[i,repj+1])/2.0
    kt=0
    for i in range(R):
        for j in range(C):
            if (x[i,0]-xi)**2/D1**2 + (y[0,j]-et)**2/D2**2 < 1:
                s0 = (dl, dl, x[i,0]-dl/2,y[0,j],dist_nucl[i,j],theta0[i,j])
                # s1 = [(dist_nucl[i,j]/vr,0),(dist_nucl[i,j]/vr+risetime,slip)]
                # P[i,j] += yy[127]
                source_i.append((s0,cct[kt]))
                kt+=1
    # plt.colorbar()
    # plt.show()
    # print(source_i)
    return source_i, m0it, maxslip, ruptvel, theta0, code


# multi_cracks_params = {name:params}
def approx_multi_cracks(multi_cracks_params):
    pass



# L, W, slip, risetime, delay, nxi, neta, vr, code  
def approx_haskell(haskell_params):
    m0it = 0
    source_i = []
    L, W, dl, slip, risetime, dtm,  nx, ny, vr, code =  haskell_params
    R = int(L/dl)
    C = int(W/dl)
    x = np.linspace(dl/2, L-dl/2, R)
    y = np.linspace(-W/2+dl/2, W/2-dl/2, C)
    x = np.expand_dims(x, axis = -1)
    y = np.expand_dims(y, axis = 0)
    xi = L/2
    et = 0.0
    ruptime = np.zeros((R,C))
    # nx = nx-L/2
    # vr = ((vrt**2 * D1**2 )/ ((D2 + np.abs(ny) * dl)**2 + (nx * dl)**2))**0.5
    # vx = vr
    # vy = D2/D1 * vx
    # th = np.pi * th/180
    # tf = max(D1/vx, D2/vy)
    # print('rtx =', D1/vx)
    # print('rtx =', D2/vy)
    # t = np.linspace(0,tf,1024)
    # ru = np.minimum(((x - xi)**2 + (y - et)**2)**0.5, D)
    # ru = ((x - nx)**2 + (y - ny)**2)**0.5
    # print('ru =',ru)
    # cosp = (x - nx)/ru
    # print(cosp)
    # p = np.sign(y-ny)*np.arccos(cosp)
    # print(p)
    # cosp = (np.cos(p))

    # d2 = (nuclp[0]-xi-nx*dl)**2 + (nuclp[1]-et-ny*dl)**2
    # tau = np.sqrt(d2)/rveln
    # print('------------------------------')
    # print('crack #', post_name, ': τ =', tau)
    # continue
    dist_nucl = np.zeros((R,C))
    theta0 = np.zeros((R,C))
    resti = []
    restj = []
    for i in range(R):
        for j in range(C):
            dist_nucl[i,j] = np.sqrt((x[i,0] -xi - nx)**2 + (y[0,j]- et -ny)**2)
            if i*dl >= nx + xi and j*dl + dl - W/2 <= ny + et:
                tanth0 = 0
                if ny + et !=  j*dl + dl - W/2:
                    tanth0 = (-nx-xi + i*dl)/(ny + et - j*dl - dl + W/2)
                    thp = np.arctan(tanth0)
                    th0 = 2*np.pi -(np.pi - np.arctan(tanth0))+np.pi/2
                else:
                    th0 = 2*np.pi
                    thp = th0
                theta0[i,j] = th0
            elif i*dl >= nx + xi and j*dl - W/2 >= ny + et:
                tanth0 = 0
                if j*dl - W/2 !=  ny + et:
                    tanth0 = (-nx-xi + i*dl)/(-ny - et + j*dl + dl - W/2)
                    thp = np.arctan(tanth0)
                    th0 = np.pi/2 - np.arctan(tanth0)
                else:
                    th0 = np.pi/2*0
                    thp = th0
                theta0[i,j] = th0
            elif i*dl +dl <= nx + xi and j*dl +dl - W/2 <= ny + et:
                tanth0 = 0
                if j*dl +dl - W/2 !=  ny + et:
                    tanth0 = (-i*dl - dl + nx + xi)/(-j*dl -dl + W/2 + ny + et)
                    thp = np.arctan(tanth0)
                    th0 = (np.pi + np.arctan(tanth0))
                else:
                    th0 = np.pi + np.pi/2
                    thp = np.pi/2
                theta0[i,j] =  3*np.pi/2 - th0 + np.pi
            elif i*dl +dl <= nx + xi and j*dl - W/2 >= ny + et:
                tanth0 = 0
                if j*dl + dl - W/2 !=  ny + et:
                    tanth0 = (-i*dl - dl + nx + xi)/(j*dl +dl - W/2 - ny - et)
                    thp = np.arctan(tanth0)
                    th0 = 3*np.pi/2 + np.pi/2 - np.arctan(tanth0)
                else:
                    th0 = 3*np.pi/2 - np.pi/2
                    thp = np.pi/2
                theta0[i,j] = 3*np.pi/2-(th0 - np.pi)
            else:
                resti.append(i)
                restj.append(j)
                if i*dl < xi:
                    theta0[i,j] = 10.0
                else:
                    theta0[i,j] = 10.0
            
            tm = dtm
            
            # ct += tm # 0.*((circ[0][1] - xi)**2 + 1*(circ[0][2] - et)**2)**0.5/vr
            # dist_nucl[i,j]=dist_nucl[i,j]/(ct[0]-tm)
            # s0 = (dl, dl, x[i,0]-dl/2,y[0,j],0.0,theta0[i,j])
            # s1 = [(dtm,0),(dtm+risetime,slip)]
            # P[i,j] += yy[127]
            # source_i.append((s0,s1))
            # sources_idx[(i,j)] = s1
            M0ij = 1.9 * 10**6 * dl**2 * slip * 1600 * 3200**2

            m0it += M0ij
    # print(resti)
    repi = -1;
    repj = -1;
    for i in range(len(resti)-1):
        if resti[i]==resti[i+1]:
            repi = resti[i]
            break
    for j in range(len(restj)-1):
        if restj[j]==restj[j+1]:
            repj = restj[j]
            break
    # print('repi=',repi)
    # print('repj=',repj)
    if repi>0:
        for j in range(C):
            theta0[repi,j]=(theta0[repi-1,j]+theta0[repi+1,j])/2.0
    if repj>0:
        for i in range(R):
            theta0[i,repj]=(theta0[i,repj-1]+theta0[i,repj+1])/2.0
    for i in range(R):
        for j in range(C):
            s0 = (dl, dl, x[i,0]-dl/2,y[0,j],dtm,theta0[i,j])
            s1 = [(dist_nucl[i,j]/vr,0),(dist_nucl[i,j]/vr+risetime,slip)]
            ruptime[i,j] = dist_nucl[i,j]/vr
            # P[i,j] += yy[127]
            source_i.append((s0,s1))
    # plt.pcolor(dist_nucl/vr)
    # plt.show()
    return source_i, m0it, ruptime, theta0, code


def latlon_to_km(lat,lon):
    p = Proj(proj='utm', zone=34, ellps='WGS84',preserve_units=False)
    y0, x0 = p(25.13, 35.34)
    y, x =  p(lon, lat)
    x = x/1000 - x0/1000 # N-S
    y = y/1000 - y0/1000 # E-W
    return x,y

def km_to_latlon(x,y):
    p = Proj(proj='utm', zone=34, ellps='WGS84',preserve_units=False)
    y0, x0 = p(25.13, 35.34)
    x = x*1000 + x0 
    y = y*1000 + y0
    lon, lat = p(y, x, inverse=True)
    return lat,lon

def hp(signal, cutoff, fs, order=5):
    nyq = 0.5 * fs
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='high', analog=False)
    y = lfilter(b, a, signal)
    return y

def lp(signal, cutoff, fs, order=5):
    nyq = 0.5 * fs
    normal_cutoff = cutoff / nyq
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    y = lfilter(b, a, signal)
    return y


def load_seis(filename):
    file = open(filename)
    data = {}
    d = []
    key = None
    cur_mode = None
    for l in file:
        if l[:3] == 'Acc' or l[:3] == 'Vel' or l[:3] == 'Dis':
            cur_mode = l[:3]
            print(cur_mode)
        elif l[0] == '-':
            key = l[1] + '_' + cur_mode
            d = []
        elif len(l)>2:
            vals = l.strip().split()
            d.append([float(vals[0]), float(vals[1])])
        else:
            data[key] = np.array(d)
    return data



def save_simulation(dir_name, receiver_name, source_name):
    pass



