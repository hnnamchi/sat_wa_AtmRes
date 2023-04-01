

begin
; ==============================================================
; User defined parameters that specify region of globe and
; ==============================================================
  latS   = -50.
  latN   =  50. 
  lonL   = -180.
  lonR   =  180.

  yrStrt = 1983
  yrLast = 2017

  season = "JAS"    ; choose Dec-Jan-Feb seasonal mean

  p95 = 0.10
  nmos = 12

; ==============================================================
; Open the file: Read only the user specified period
; ==============================================================
  f      = addfile("eof_ts.nc", "r")

  TIME   = f->time
  YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
  iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

  eof_ts    = f->eof_ts(:,iYYYY)
  printVarSummary(eof_ts)                              ; variable overview
  
  eof_ts = dim_standardize_n(eof_ts,1,1)  ; new variable
delete(f)
delete(TIME)
delete(YYYY)
delete(iYYYY)

eof_ts_nt = eof_ts		;transfers metadata
eof_ts_nt = dtrend_n(eof_ts_nt,False,1)		;removes linear trend
;
;
t = eof_ts		;transfers metadata
t = eof_ts - eof_ts_nt		;trend line 
;=================================================================
;=================================================================
;================================================================
; ===============================================================
; Open the file: Read only the user specified period
; ==============================================================
f      = addfile ("/home/hnnamchi/work/datasets/rain/GPCP_precip.mon.mean.nc", "r")
TIME   = f->time
YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

rain    = short2flt(f->precip(iYYYY,{latS:latN},:))
rain = lonFlip(rain)
printVarSummary(rain)       ; variable overview

printMinMax(rain,True)

rain!1  =  "lat"
rain!2  =  "lon"
delete([/YYYY,iYYYY,f,TIME/])
;==============================================================
;===========================
;=============================================================================================================
 rain_d = new(dimsizes(rain),typeof(rain),rain@_FillValue)
 x   = rain&time
 x1  = x(::12)
 do tt = 0,nmos-1
    work =rain(tt::nmos,:,:)
    work = dtrend_msg_n(x1,work,False,False,0)		;detrend but retain mean
    rain_d(tt::nmos,:,:) = work
 end do

 printVarSummary(rain_d)
 rain = rain_d

;===
delete([/tt,x,x1,rain_d,work/])
;
;
RAIN = month_to_season(rain,season)
printVarSummary(RAIN)
;
m_RAIN = dim_avg_n_Wrap(RAIN,0)
printVarSummary(m_RAIN)
;
;delete(RAIN)
delete(rain)
;---------------------------------------------------------------------------
; ==============================================================
; Open the file: Read only the user specified period
; ==============================================================
;  f      = addfile("/home/hyacinth/work/datasets/sst/OISST_sst.mnmean.nc", "r")
f      = addfile("/home/hnnamchi/work/datasets/olr/olr.mon.mean.nc", "r")

  TIME   = f->time
  YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
  iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

  sst    = f->olr(iYYYY,:,:)
  printVarSummary(sst)                              ; variable overview
  ;print(xxxxxxxxxxx)

delete(f)
delete(TIME)
delete(YYYY)
delete(iYYYY)
 
   a    = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
   lsdata = a->LSMASK
   lsm  = landsea_mask(lsdata,sst&lat,sst&lon)
 ;  sst = mask(sst,lsm.eq.0,True)
; 
  delete(a)
  delete(lsm)  
; ==============================================================
  sst    = lonFlip(sst)
  printVarSummary(sst)                              ; note the longitude coord

;=========================================================================================
;------------------------------------------------------------------
; ==============================================================
; compute desired global seasonal mean: month_to_season (contributed.ncl) 
; ==============================================================
 ; SST    = month_to_season(sst, season)
  SST = month_to_season(sst,season)
 ; SST!0  = "lev"
  printVarSummary(SST)
 

 ; SST = dim_standardize_n(SST,1,0)  ; normalize

  ;SST = dtrend_msg_n(SST&time,SST,True,False,0)




;---------------------------------------------------
pc1 = eof_ts(0,:)
;
dimZ = dimsizes(SST)
printVarSummary(dimZ)
n_pc1P = dim_num_n(pc1.gt.1.0,0)	   ;Number of cases
print(n_pc1P) 		
pc1P_cases = (pc1.ge.1.0)
print(pc1P_cases)
;
pc1P_cases_maps  = new ((/n_pc1P,dimZ(1),dimZ(2)/),float,SST@_FillValue)
printVarSummary(pc1P_cases_maps)                
valsP = ind(pc1.ge.1.0)
print(valsP+yrStrt)
pc1P_cases_maps = SST(valsP,:,:)
;
;
n_pc1N = dim_num_n(pc1.lt.-1.0,0)	   ;Number of cases
print(n_pc1N) 		
pc1N_cases = (pc1.lt.-1.0)
print(pc1N_cases)
;
pc1N_cases_maps  = new ((/n_pc1N,dimZ(1),dimZ(2)/),float,SST@_FillValue)
printVarSummary(pc1N_cases_maps)                
valsN = ind(pc1.lt.-1.0)
print(valsN+yrStrt)
pc1N_cases_maps = SST(valsN,:,:)
;print(xxxxxxxxxxxxx)
;
;
pc1SST = (dim_avg_n_Wrap(pc1P_cases_maps,0)- dim_avg_n_Wrap(pc1N_cases_maps,0))/2.
copy_VarCoords(SST(time|0,lat|:,lon|:),pc1SST)                             ; copy coordinate arrays 
printVarSummary(pc1SST)
printMinMax(pc1SST,True)
;
;
;===================================== 
pc1SSTd = pc1SST  ; Transfer metdata for plotting sig. values        

pc1SSTd = ttest((dim_avg_n_Wrap(pc1P_cases_maps,0)),(dim_stddev_n_Wrap(pc1P_cases_maps,0))^2,n_pc1P\
               ,(dim_avg_n_Wrap(pc1N_cases_maps,0)),(dim_stddev_n_Wrap(pc1N_cases_maps,0))^2,n_pc1N,True, False)
pc1SSTd@long_name = "Probability: difference between means"
printVarSummary(pc1SSTd)

pc1SSTd = where(abs(pc1SSTd).le.p95,pc1SST,pc1SST@_FillValue) ; 
print("==============================================================")  
printVarSummary(pc1SSTd)
printMinMax(pc1SSTd,True)
print("==============================================================")
;
delete(sst)
delete(pc1P_cases_maps)
delete(pc1N_cases_maps)
delete(pc1)
delete(valsP)
delete(valsN)
delete(pc1P_cases)
delete(pc1N_cases)
delete(n_pc1P)
delete(n_pc1N)
list_vars()


;---------------------------------------------------
pc2 = eof_ts(1,:)
;
n_pc2P = dim_num_n(pc2.gt.1.0,0)	   ;Number of cases
print(n_pc2P) 		
pc2P_cases = (pc2.ge.1.0)
print(pc2P_cases)
;
pc2P_cases_maps  = new ((/n_pc2P,dimZ(1),dimZ(2)/),float,SST@_FillValue)
printVarSummary(pc2P_cases_maps)                
valsP = ind(pc2.ge.1.0)
print(valsP+yrStrt)
pc2P_cases_maps = SST(valsP,:,:)
;
;
n_pc2N = dim_num_n(pc2.lt.-1.0,0)	   ;Number of cases
print(n_pc2N) 		
pc2N_cases = (pc2.lt.-1.0)
print(pc2N_cases)
;
pc2N_cases_maps  = new ((/n_pc2N,dimZ(1),dimZ(2)/),float,SST@_FillValue)
printVarSummary(pc2N_cases_maps)                
valsN = ind(pc2.lt.-1.0)
print(valsN+yrStrt)
pc2N_cases_maps = SST(valsN,:,:)
;print(xxxxxxxxxxxxxx)
;
;
pc2SST = (dim_avg_n_Wrap(pc2P_cases_maps,0)- dim_avg_n_Wrap(pc2N_cases_maps,0))/2.
copy_VarCoords(SST(time|0,lat|:,lon|:),pc2SST)                             ; copy coordinate arrays 
printVarSummary(pc2SST)
printMinMax(pc2SST,True)
;
;
;===================================== 
pc2SSTd = pc2SST  ; Transfer metdata for plotting sig. values        

pc2SSTd = ttest((dim_avg_n_Wrap(pc2P_cases_maps,0)),(dim_stddev_n_Wrap(pc2P_cases_maps,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_cases_maps,0)),(dim_stddev_n_Wrap(pc2N_cases_maps,0))^2,n_pc2N,True, False)
pc2SSTd@long_name = "Probability: difference between means"
printVarSummary(pc2SSTd)

pc2SSTd = where(abs(pc2SSTd).le.p95,pc2SST,pc2SST@_FillValue) ; 
print("==============================================================")  
printVarSummary(pc2SSTd)
printMinMax(pc2SSTd,True)
print("==============================================================")
;
delete(pc2P_cases_maps)
delete(pc2N_cases_maps)
delete(pc2)
delete(valsP)
delete(valsN)
delete(pc2P_cases)
delete(pc2N_cases)
delete(dimZ)
delete(n_pc2P)
delete(n_pc2N)
list_vars()
;
;
;---------------------------------------------------
; =================================================================
;-------------------------------------------------------------------------
;Remove the linear trends
;& repeat the analysis

SST = dtrend_msg_n(SST&time,SST,True,False,0)
;-------------------------------------------------------------------------
pc1 = eof_ts_nt(0,:)
;
dimZ = dimsizes(SST)
printVarSummary(dimZ)
n_pc1P = dim_num_n(pc1.gt.1.0,0)	   ;Number of cases
print(n_pc1P) 		
pc1P_cases = (pc1.ge.1.0)
print(pc1P_cases)
;
pc1P_cases_maps  = new ((/n_pc1P,dimZ(1),dimZ(2)/),float,SST@_FillValue)
printVarSummary(pc1P_cases_maps)                
valsP = ind(pc1.ge.1.0)
print(valsP+yrStrt)
pc1P_cases_maps = SST(valsP,:,:)
;
;
n_pc1N = dim_num_n(pc1.lt.-1.0,0)	   ;Number of cases
print(n_pc1N) 		
pc1N_cases = (pc1.lt.-1.0)
print(pc1N_cases)
;
pc1N_cases_maps  = new ((/n_pc1N,dimZ(1),dimZ(2)/),float,SST@_FillValue)
printVarSummary(pc1N_cases_maps)                
valsN = ind(pc1.lt.-1.0)
print(valsN+yrStrt)
pc1N_cases_maps = SST(valsN,:,:)
;print(xxxxxxxxxxxxx)
;
;
pc1SST_nt = (dim_avg_n_Wrap(pc1P_cases_maps,0)- dim_avg_n_Wrap(pc1N_cases_maps,0))/2.
copy_VarCoords(SST(time|0,lat|:,lon|:),pc1SST_nt)                             ; copy coordinate arrays 
printVarSummary(pc1SST_nt)
printMinMax(pc1SST_nt,True)
;print(xxxxxxxxxxxxxxxxx)
;
;
;===================================== 
pc1SST_ntd = pc1SST_nt  ; Transfer metdata for plotting sig. values        

pc1SST_ntd = ttest((dim_avg_n_Wrap(pc1P_cases_maps,0)),(dim_stddev_n_Wrap(pc1P_cases_maps,0))^2,n_pc1P\
               ,(dim_avg_n_Wrap(pc1N_cases_maps,0)),(dim_stddev_n_Wrap(pc1N_cases_maps,0))^2,n_pc1N,True, False)
pc1SST_ntd@long_name = "Probability: difference between means"
printVarSummary(pc1SST_ntd)

pc1SST_ntd = where(abs(pc1SST_ntd).le.p95,pc1SST_nt,pc1SST_nt@_FillValue) ; 
print("==============================================================")  
printVarSummary(pc1SST_ntd)
printMinMax(pc1SST_ntd,True)
print("==============================================================")
;
delete(pc1P_cases_maps)
delete(pc1N_cases_maps)
delete(pc1)
delete(valsP)
delete(valsN)
delete(pc1P_cases)
delete(pc1N_cases)
delete(n_pc1P)
delete(n_pc1N)
list_vars()


;---------------------------------------------------
pc2 = eof_ts_nt(1,:)
;
n_pc2P = dim_num_n(pc2.gt.1.0,0)	   ;Number of cases
print(n_pc2P) 		
pc2P_cases = (pc2.ge.1.0)
print(pc2P_cases)
;
pc2P_cases_maps  = new ((/n_pc2P,dimZ(1),dimZ(2)/),float,SST@_FillValue)
printVarSummary(pc2P_cases_maps)                
valsP = ind(pc2.ge.1.0)
print(valsP+yrStrt)
pc2P_cases_maps = SST(valsP,:,:)
;
;
n_pc2N = dim_num_n(pc2.lt.-1.0,0)	   ;Number of cases
print(n_pc2N) 		
pc2N_cases = (pc2.lt.-1.0)
print(pc2N_cases)
;
pc2N_cases_maps  = new ((/n_pc2N,dimZ(1),dimZ(2)/),float,SST@_FillValue)
printVarSummary(pc2N_cases_maps)                
valsN = ind(pc2.lt.-1.0)
print(valsN+yrStrt)
pc2N_cases_maps = SST(valsN,:,:)
;
;
pc2SST_nt = (dim_avg_n_Wrap(pc2P_cases_maps,0)- dim_avg_n_Wrap(pc2N_cases_maps,0))/2.
copy_VarCoords(SST(time|0,lat|:,lon|:),pc2SST_nt)                             ; copy coordinate arrays 
printVarSummary(pc2SST_nt)
printMinMax(pc2SST_nt,True)
;print(xxxxxxxxxxxxxx)
;
;
;===================================== 
pc2SST_ntd = pc2SST_nt  ; Transfer metdata for plotting sig. values        

pc2SST_ntd = ttest((dim_avg_n_Wrap(pc2P_cases_maps,0)),(dim_stddev_n_Wrap(pc2P_cases_maps,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_cases_maps,0)),(dim_stddev_n_Wrap(pc2N_cases_maps,0))^2,n_pc2N,True, False)
pc2SST_ntd@long_name = "Probability: difference between means"
printVarSummary(pc2SST_ntd)

pc2SST_ntd = where(abs(pc2SST_ntd).le.p95,pc2SST_nt,pc2SST_nt@_FillValue) ; 
print("==============================================================")  
printVarSummary(pc2SST_ntd)
printMinMax(pc2SST_ntd,True)
print("==============================================================")
;
delete(pc2P_cases_maps)
delete(pc2N_cases_maps)
delete(pc2)
delete(valsP)
delete(valsN)
delete(pc2P_cases)
delete(pc2N_cases)
delete(dimZ)
delete(n_pc2P)
delete(n_pc2N)
list_vars()
;
;
;
;==================================================================
;==================================================================




































;---------------------------------------------------
pc1 = eof_ts(0,:)
;
dimZ = dimsizes(RAIN)
printVarSummary(dimZ)
n_pc1P = dim_num_n(pc1.gt.1.0,0)	   ;Number of cases
print(n_pc1P) 		
pc1P_cases = (pc1.ge.1.0)
print(pc1P_cases)
;
pc1P_cases_maps  = new ((/n_pc1P,dimZ(1),dimZ(2)/),float,RAIN@_FillValue)
printVarSummary(pc1P_cases_maps)                
valsP = ind(pc1.ge.1.0)
print(valsP+yrStrt)
pc1P_cases_maps = RAIN(valsP,:,:)
;
;
n_pc1N = dim_num_n(pc1.lt.-1.0,0)	   ;Number of cases
print(n_pc1N) 		
pc1N_cases = (pc1.lt.-1.0)
print(pc1N_cases)
;
pc1N_cases_maps  = new ((/n_pc1N,dimZ(1),dimZ(2)/),float,RAIN@_FillValue)
printVarSummary(pc1N_cases_maps)                
valsN = ind(pc1.lt.-1.0)
print(valsN+yrStrt)
pc1N_cases_maps = RAIN(valsN,:,:)
;
;
pc1RAIN = (dim_avg_n_Wrap(pc1P_cases_maps,0)- dim_avg_n_Wrap(pc1N_cases_maps,0))/2.
copy_VarCoords(RAIN(time|0,lat|:,lon|:),pc1RAIN)                             ; copy coordinate arrays 
printVarSummary(pc1RAIN)
printMinMax(pc1RAIN,True)
;
;
;===================================== 
pc1RAINd = pc1RAIN  ; Transfer metdata for plotting sig. values        

pc1RAINd = ttest((dim_avg_n_Wrap(pc1P_cases_maps,0)),(dim_stddev_n_Wrap(pc1P_cases_maps,0))^2,n_pc1P\
               ,(dim_avg_n_Wrap(pc1N_cases_maps,0)),(dim_stddev_n_Wrap(pc1N_cases_maps,0))^2,n_pc1N,True, False)
pc1RAINd@long_name = "Probability: difference between means"
printVarSummary(pc1RAINd)

pc1RAINd = where(abs(pc1RAINd).le.p95,pc1RAIN,pc1RAIN@_FillValue) ; 
print("==============================================================")  
printVarSummary(pc1RAINd)
printMinMax(pc1RAINd,True)
print("==============================================================")
;
delete(pc1P_cases_maps)
delete(pc1N_cases_maps)
delete(pc1)
delete(valsP)
delete(valsN)
delete(pc1P_cases)
delete(pc1N_cases)
delete(n_pc1P)
delete(n_pc1N)
list_vars()


;---------------------------------------------------
pc2 = eof_ts(1,:)
;
n_pc2P = dim_num_n(pc2.gt.1.0,0)	   ;Number of cases
print(n_pc2P) 		
pc2P_cases = (pc2.ge.1.0)
print(pc2P_cases)
;
pc2P_cases_maps  = new ((/n_pc2P,dimZ(1),dimZ(2)/),float,RAIN@_FillValue)
printVarSummary(pc2P_cases_maps)                
valsP = ind(pc2.ge.1.0)
print(valsP+yrStrt)
pc2P_cases_maps = RAIN(valsP,:,:)
;
;
n_pc2N = dim_num_n(pc2.lt.-1.0,0)	   ;Number of cases
print(n_pc2N) 		
pc2N_cases = (pc2.lt.-1.0)
print(pc2N_cases)
;
pc2N_cases_maps  = new ((/n_pc2N,dimZ(1),dimZ(2)/),float,RAIN@_FillValue)
printVarSummary(pc2N_cases_maps)                
valsN = ind(pc2.lt.-1.0)
print(valsN+yrStrt)
pc2N_cases_maps = RAIN(valsN,:,:)
;
;
pc2RAIN = (dim_avg_n_Wrap(pc2P_cases_maps,0)- dim_avg_n_Wrap(pc2N_cases_maps,0))/2.
copy_VarCoords(RAIN(time|0,lat|:,lon|:),pc2RAIN)                             ; copy coordinate arrays 
printVarSummary(pc2RAIN)
printMinMax(pc2RAIN,True)
;
;
;===================================== 
pc2RAINd = pc2RAIN  ; Transfer metdata for plotting sig. values        

pc2RAINd = ttest((dim_avg_n_Wrap(pc2P_cases_maps,0)),(dim_stddev_n_Wrap(pc2P_cases_maps,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_cases_maps,0)),(dim_stddev_n_Wrap(pc2N_cases_maps,0))^2,n_pc2N,True, False)
pc2RAINd@long_name = "Probability: difference between means"
printVarSummary(pc2RAINd)

pc2RAINd = where(abs(pc2RAINd).le.p95,pc2RAIN,pc2RAIN@_FillValue) ; 
print("==============================================================")  
printVarSummary(pc2RAINd)
printMinMax(pc2RAINd,True)
print("==============================================================")
;
delete(pc2P_cases_maps)
delete(pc2N_cases_maps)
delete(pc2)
delete(valsP)
delete(valsN)
delete(pc2P_cases)
delete(pc2N_cases)
delete(dimZ)
delete(n_pc2P)
delete(n_pc2N)
list_vars()
;
;
;---------------------------------------------------
; =================================================================
;-------------------------------------------------------------------------
;Remove the linear trends
;& repeat the analysis

RAIN = dtrend_msg_n(RAIN&time,RAIN,True,False,0)
;-------------------------------------------------------------------------
pc1 = eof_ts_nt(0,:)
;
dimZ = dimsizes(RAIN)
printVarSummary(dimZ)
n_pc1P = dim_num_n(pc1.gt.1.0,0)	   ;Number of cases
print(n_pc1P) 		
pc1P_cases = (pc1.ge.1.0)
print(pc1P_cases)
;
pc1P_cases_maps  = new ((/n_pc1P,dimZ(1),dimZ(2)/),float,RAIN@_FillValue)
printVarSummary(pc1P_cases_maps)                
valsP = ind(pc1.ge.1.0)
print(valsP+yrStrt)
pc1P_cases_maps = RAIN(valsP,:,:)
;
;
n_pc1N = dim_num_n(pc1.lt.-1.0,0)	   ;Number of cases
print(n_pc1N) 		
pc1N_cases = (pc1.lt.-1.0)
print(pc1N_cases)
;
pc1N_cases_maps  = new ((/n_pc1N,dimZ(1),dimZ(2)/),float,RAIN@_FillValue)
printVarSummary(pc1N_cases_maps)                
valsN = ind(pc1.lt.-1.0)
print(valsN+yrStrt)
pc1N_cases_maps = RAIN(valsN,:,:)
;
;
pc1RAIN_nt = (dim_avg_n_Wrap(pc1P_cases_maps,0)- dim_avg_n_Wrap(pc1N_cases_maps,0))/2.
copy_VarCoords(RAIN(time|0,lat|:,lon|:),pc1RAIN_nt)                             ; copy coordinate arrays 
printVarSummary(pc1RAIN_nt)
printMinMax(pc1RAIN_nt,True)
;
;
;===================================== 
pc1RAIN_ntd = pc1RAIN_nt  ; Transfer metdata for plotting sig. values        

pc1RAIN_ntd = ttest((dim_avg_n_Wrap(pc1P_cases_maps,0)),(dim_stddev_n_Wrap(pc1P_cases_maps,0))^2,n_pc1P\
               ,(dim_avg_n_Wrap(pc1N_cases_maps,0)),(dim_stddev_n_Wrap(pc1N_cases_maps,0))^2,n_pc1N,True, False)
pc1RAIN_ntd@long_name = "Probability: difference between means"
printVarSummary(pc1RAIN_ntd)

pc1RAIN_ntd = where(abs(pc1RAIN_ntd).le.p95,pc1RAIN_nt,pc1RAIN_nt@_FillValue) ; 
print("==============================================================")  
printVarSummary(pc1RAIN_ntd)
printMinMax(pc1RAIN_ntd,True)
print("==============================================================")
;
delete(pc1P_cases_maps)
delete(pc1N_cases_maps)
delete(pc1)
delete(valsP)
delete(valsN)
delete(pc1P_cases)
delete(pc1N_cases)
delete(n_pc1P)
delete(n_pc1N)
list_vars()


;---------------------------------------------------
pc2 = eof_ts_nt(1,:)
;
n_pc2P = dim_num_n(pc2.gt.1.0,0)	   ;Number of cases
print(n_pc2P) 		
pc2P_cases = (pc2.ge.1.0)
print(pc2P_cases)
;
pc2P_cases_maps  = new ((/n_pc2P,dimZ(1),dimZ(2)/),float,RAIN@_FillValue)
printVarSummary(pc2P_cases_maps)                
valsP = ind(pc2.ge.1.0)
print(valsP+yrStrt)
pc2P_cases_maps = RAIN(valsP,:,:)
;
;
n_pc2N = dim_num_n(pc2.lt.-1.0,0)	   ;Number of cases
print(n_pc2N) 		
pc2N_cases = (pc2.lt.-1.0)
print(pc2N_cases)
;
pc2N_cases_maps  = new ((/n_pc2N,dimZ(1),dimZ(2)/),float,RAIN@_FillValue)
printVarSummary(pc2N_cases_maps)                
valsN = ind(pc2.lt.-1.0)
print(valsN+yrStrt)
pc2N_cases_maps = RAIN(valsN,:,:)
;
;
pc2RAIN_nt = (dim_avg_n_Wrap(pc2P_cases_maps,0)- dim_avg_n_Wrap(pc2N_cases_maps,0))/2.
copy_VarCoords(RAIN(time|0,lat|:,lon|:),pc2RAIN_nt)                             ; copy coordinate arrays 
printVarSummary(pc2RAIN_nt)
printMinMax(pc2RAIN_nt,True)
;
;
;===================================== 
pc2RAIN_ntd = pc2RAIN_nt  ; Transfer metdata for plotting sig. values        

pc2RAIN_ntd = ttest((dim_avg_n_Wrap(pc2P_cases_maps,0)),(dim_stddev_n_Wrap(pc2P_cases_maps,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_cases_maps,0)),(dim_stddev_n_Wrap(pc2N_cases_maps,0))^2,n_pc2N,True, False)
pc2RAIN_ntd@long_name = "Probability: difference between means"
printVarSummary(pc2RAIN_ntd)

pc2RAIN_ntd = where(abs(pc2RAIN_ntd).le.p95,pc2RAIN_nt,pc2RAIN_nt@_FillValue) ; 
print("==============================================================")  
printVarSummary(pc2RAIN_ntd)
printMinMax(pc2RAIN_ntd,True)
print("==============================================================")
;
delete(pc2P_cases_maps)
delete(pc2N_cases_maps)
delete(pc2)
delete(valsP)
delete(valsN)
delete(pc2P_cases)
delete(pc2N_cases)
delete(dimZ)
delete(n_pc2P)
delete(n_pc2N)
list_vars()
;
;
;
;==================================================================
;==================================================================
;============================================================
;============================================================
; PLOTS
;============================================================
  wks = gsn_open_wks("eps","fn0_11")         ; send graphics to PNG file
  plot = new(8,graphic)                ; create graphic array
                                          ; only needed if paneling
  plotS = new(8,graphic)                ; create graphic array
  plotR = new(8,graphic)                ; create graphic array
; EOF patterns

  res                      = True         
  res@gsnDraw              = False        ; don't draw yet
  res@gsnFrame             = False        ; don't advance frame yet
  ;res@mpProjection    	   = "Robinson"       ; choose projection
  res@cnLevelSelectionMode = "ManualLevels"  ; set manual contour levels
  res@cnMinLevelValF       = -8.            ; set min contour level
  res@cnMaxLevelValF       =  8.             ; set max contour level
  res@cnLevelSpacingF      =  0.5            ; set contour spacing  
 
  res@mpFillOn             = False        ; turn off map fill
  res@pmTickMarkDisplayMode = "Always"
  res@mpMinLatF            = latS         ; zoom in on map
  res@mpMaxLatF            = latN
  res@mpMinLonF            = lonL
  res@mpMaxLonF            = lonR
  ;res@tmXBLabelsOn          = False      ;no lon ticks
  ;res@tmYLMode   = "Explicit"
  ;res@tmYLValues = ispan(-10,10,10)
  ;res@tmYLLabels = (/"10~S~o~N~S", "0~S~o~N","10~S~o~N~N"/)
  ;res@tmYLMinorValues  = ispan(-15,20,5) 
  res@tmYLLabelFontHeightF = 0.015

 ; res@tmXBMode   = "Explicit"
  ;res@tmXBValues = ispan(-60,20,20)
  ;res@tmXBLabels = (/"60~S~o~N~W", "40~S~o~N~W","20~S~o~N~W","0~S~o~N", \
  ;                   "20~S~o~N~E"/)
  ;res@tmXBMinorValues  = ispan(-60,20,10)
  res@tmXBLabelFontHeightF = 0.015
      
;  res@mpGeophysicalLineColor  = "black" 
  res@mpFillDrawOrder      = "preDraw"

  res@gsnAddCyclic         = True
  res@cnFillOn             = True         ; turn on color fill
  res@cnLinesOn            = False        ; True is default
  res@cnLineLabelsOn       = False        ; True is default
  res@cnMissingValFillColor = "grey" ; comment this line out 
  ;res@cnFillPalette        = "BlueWhiteOrangeRed"  
  res@mpOceanFillColor        = "white"
  res@mpGeophysicalLineColor  = "grey35" 
  ;cmap = read_colormap_file("ncl_default")
  ;cmap = read_colormap_file("cmp_b2r")
  ;cmap_r = cmap(::-1,:)
  ;res@cnFillPalette = cmap_r ; for the reverse color map 
  res@cnFillPalette = "ncl_default"
  
  res@lbLabelBarOn         =  False       ; turn off individual lb's
  res@lbOrientation        = "vertical"
  res@lbTitleFontHeightF  = .013 
  res@lbLabelFontHeightF   = 0.013
  res@lbLeftMarginF         = 0.10
  res@lbRightMarginF        = 0.55
  res@lbLabelFont   		     = "Helvetica-Bold"     ; label font
  res@lbTitleString        = "SST trend (K per 24-yr)"
  ;res@lbTitleString        = "SST trend (~S~o~N~C per 35-yr)"
  res@lbTitleAngleF        = 270.
  res@lbTitlePosition      = "Right"
  res@lbTitleDirection     = "Across"
  
  res@lbLabelStride        = 10

  ;res@vpHeightF 	  = 0.80        ; Changes the aspect ratio
  ;res@vpWidthF 		  = 0.40
  res@gsnCenterStringFontHeightF   = 0.025
 ; res@vpXF      = 0.30        ; change start locations
 ; res@vpYF      = 0.75        ; the plot
  

 
  ;res@tmXBMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  ;res@tmXBMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  ;res@tmYLMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  ;res@tmYLMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  ;res@tmXTMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  ;res@tmXTMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  ;res@tmYRMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  ;res@tmYRMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
;=============================================================================
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
;-----------------------------------------------------------------------------
  res1                      =   True
  res1@gsnDraw              = False        ; don't draw yet
  res1@gsnFrame             = False        ; don't advance frame yet
  res1@cnLevelSelectionMode = "ManualLevels"  ; set manual contour levels
  res1@cnMinLevelValF       =  -15.            ; set min contour level
  res1@cnMaxLevelValF       =  15.             ; set max contour level
  res1@cnLevelSpacingF      =  0.5            ; set contour spacing  
  res1@gsnAddCyclic         = False   
  res1@cnLinesOn            = False       ; True is default
  res1@cnLineLabelsOn       = False        ; True is default
  res1@cnInfoLabelOn        = False
  res1@gsnRightString   = ""
  res1@gsnLeftString   = ""
  res1@cnFillScaleF        = 0.7         ; add extra density
  ;res1@cnLineLabelDensityF =  -10.
  res1@cnFillDotSizeF       = 0.0001            ; increase dot size of contours
;-----------------------------------------------------------------------------
  res2                      =   True
  res2@gsnDraw              = False        ; don't draw yet
  res2@gsnFrame             = False        ; don't advance frame yet
  res2@cnLevelSelectionMode = "ManualLevels"  ; set manual contour levels
  res2@cnMinLevelValF       =  5.            ; set min contour level
  res2@cnMaxLevelValF       =  30.             ; set max contour level
  res2@cnLevelSpacingF      =  5.            ; set contour spacing  
  res2@cnMonoLineColor	    = True
  res2@cnLineColor	    = "black"
  res2@gsnAddCyclic         = False   
  res2@cnLinesOn            = True       ; True is default
  res2@cnLineLabelsOn       = False        ; True is default
  res2@cnInfoLabelOn        = False
  res2@gsnRightString   = ""
  res2@gsnLeftString   = ""
  res2@cnFillScaleF        = 2.         ; add extra density
  res2@cnLineThicknessF	   = 1.5
  ;res2@cnLineLabelDensityF =  -10.
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
  opt = True
  opt@gsnShadeFillType = "pattern"        ; color is the default
  opt@gsnShadeLow = 17                     ; use fill pattern #4
  opt@gsnShadeHigh = 17                  ; use pattern #2   
  ;opt@gsnShadeMid = 2   
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
 res@gsnCenterStringFontHeightF   = 0.015
 res@gsnCenterString  = ""
 res@gsnRightString  = ""  
 res@gsnLeftString  = ""  
 res@tmYLLabelsOn          = True      ;no lon ticks
 res@tmXBLabelsOn          = True      ;no lon ticks
 
   
  DATA_NAMES = (/"Trend + Variability","Trend + Variability","No trend","No trend"/)
   ; res@gsnCenterString  = DATA_NAMES(n)
  res@gsnAddCyclic         = False
  res@gsnLeftStringOrthogonalPosF = 0.0
  res@gsnLeftStringParallelPosF =   0.05
  ;res@gsnLeftStringFontColor = "grey25"
 
   res@gsnCenterString  = "Trend + Variability"
   plotA0 = gsn_csm_contour_map(wks,pc1SST,res)
   plotS0 = gsn_csm_contour(wks,pc1SSTd,res1)
   plotS0 = gsn_contour_shade(plotS0,p95,pc1SSTd@_FillValue,opt)
   overlay(plotA0,plotS0)
   plot(0) = plotA0
;
   plotA1 = gsn_csm_contour_map(wks,pc2SST_nt,res)
   plotS1 = gsn_csm_contour(wks,pc2SSTd,res1)
   plotS1 = gsn_contour_shade(plotS1,p95,pc2SSTd@_FillValue,opt)
   overlay(plotA1,plotS1)
   plot(1) = plotA1

 ; No trends
   res@gsnCenterString  = "No trend"
   plotA2 = gsn_csm_contour_map(wks,pc1SST_nt,res)
   plotS2 = gsn_csm_contour(wks,pc1SST_ntd,res1)
   plotS2 = gsn_contour_shade(plotS2,p95,pc1SST_ntd@_FillValue,opt)
   overlay(plotA2,plotS2)
   plot(2) = plotA2
;
  
   plotA3 = gsn_csm_contour_map(wks,pc2SST_nt,res)
   plotS3 = gsn_csm_contour(wks,pc2SST_ntd,res1)
   plotS3 = gsn_contour_shade(plotS3,p95,pc2SST_ntd@_FillValue,opt)
   overlay(plotA3,plotS3)
   plot(3) = plotA3

;======================================================================
  res@cnLevelSelectionMode = "ManualLevels"  ; set manual contour levels
  res@cnMinLevelValF       = -2.            ; set min contour level
  res@cnMaxLevelValF       =  2.             ; set max contour level
  res@cnLevelSpacingF      =  0.05            ; set contour spacing  
 
res@gsnCenterString  = "Trend + Variability"
   plotA4 = gsn_csm_contour_map(wks,pc1RAIN,res)
   plotS4 = gsn_csm_contour(wks,pc1RAINd,res1)
   plotS4 = gsn_contour_shade(plotS4,p95,pc1RAINd@_FillValue,opt)
   overlay(plotA4,plotS4)
   plot(4) = plotA4
;
   plotA5 = gsn_csm_contour_map(wks,pc2RAIN_nt,res)
   plotS5 = gsn_csm_contour(wks,pc2RAINd,res1)
   plotS5 = gsn_contour_shade(plotS5,p95,pc2RAINd@_FillValue,opt)
   overlay(plotA5,plotS5)
   plot(5) = plotA5

 ; No trends
   res@gsnCenterString  = "No trend"
   plotA6 = gsn_csm_contour_map(wks,pc1RAIN_nt,res)
   plotS6 = gsn_csm_contour(wks,pc1RAIN_ntd,res1)
   plotS6 = gsn_contour_shade(plotS6,p95,pc1RAIN_ntd@_FillValue,opt)
   overlay(plotA6,plotS6)
   plot(6) = plotA6
;
  
   plotA7 = gsn_csm_contour_map(wks,pc2RAIN_nt,res)
   plotS7 = gsn_csm_contour(wks,pc2RAIN_ntd,res1)
   plotS7 = gsn_contour_shade(plotS7,p95,pc2RAIN_ntd@_FillValue,opt)
   overlay(plotA7,plotS7)
   plot(7) = plotA7







do n=0,7,1			;overlay mean rainfall on all plots
  plotR(n) = gsn_csm_contour(wks,m_RAIN,res2)
  overlay(plot(n),plotR(n))
  plot(n) = plot(n)
end do

;
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;---------------------------------------------------------------------
var_names = (/"Sahel mode","Guinea Coast mode"/)
printVarSummary(var_names)
print(var_names)

  txres               = True         ; Text resources
  txres@txFontHeightF = 0.012
  txres@txJust        = "CenterLeft"
  txres@txFont                = "Helvetica-Bold"
  txres@txAngleF      =  0.

  labels0  = var_names
  xpos0    = fspan(0.22, 0.68,dimsizes(var_names))

 do i = 0,dimsizes(labels0)-1,1
     gsn_text_ndc(wks,labels0(i),xpos0(i),0.98,txres)
  end do
delete(i)
delete(txres)
;=====================================================================
;=====================================================================

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
;=========================================================================
;=========================================================================
;=========================================================================
  txres5               = True
  txres5@txAngleF      = 0.          ; Rotate string clockwise 
  txres5@txFontHeightF = 0.020   ; Use same font height as left axis
  txres5@txFont                = "Helvetica-Bold"
 ; txid = gsn_create_text(wks, "DT anomaly (~S~o~N~C)", txres)
   txid5 = gsn_create_text(wks, "a", txres5);
; Move text string to center/right edge of plot.;
  amres5                  = True
  ;amres5@amParallelPosF   =  -0.60 ; 0.5 is the right edge of the plot, so
                                  ; 0.6 is a little further to the right.
  ;amres5@amOrthogonalPosF =  -0.60   ; This is the center of the plot.

  amres5@amParallelPosF   =  -0.50 ; 0.5 is the right edge of the plot, so
  amres5@amOrthogonalPosF =  -0.55    ; This is the center of the plot.
  amres5@amJust           = "TopLeft"
 ; annoid5 = gsn_add_annotation(plot(6),txid5,amres5)  ; Attach string to plot


; amres5@amParallelPosF   =  -0.65 ; 0.5 is the right edge of the plot, so


 amres5@amParallelPosF   =  -0.50 ; 0.5 is the right edge of the plot, so
 amres5@amOrthogonalPosF =  -0.45    ; This is the center of the plot.
 

 tt = (/"(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)","(j)","(k)","(l)","(m)","(n)","(o)","(p)","(q)","(r)","(s)","(t)","(u)","(v)","(w)"/)
 create_tt = gsn_create_text(wks,tt,txres5);
tt_p0 = new(8,graphic)                ; create graphic array ; only needed if paneling
tt_p1 = new(8,graphic)
;---Attach the polyline
     do i = 0,7,1
      tt_p0(i) = gsn_add_annotation(plot(i),create_tt(i),amres5)
     ; tt_p1(i) = gsn_add_annotation(plot(i+2),create_tt(i+2),amres5)
     end do 
 delete(i)
;
;
;===============================================================
;==============================================================
  latEQ = (/ 0.,  10.,  10.,   0., 0./)
  lonEQ = (/-20., 20., 20., -20.,-20./)

;---Resources for the polyline
  pres0                  = True           ; polyline mods desired
  pres0@gsLineThicknessF = 0.5            ; line thickness   
  pres0@gsLineColor      = "black"         ; color of lines
  pres0@gsLineDashPattern = 14
  pres0@tfPolyDrawOrder   = "postDraw"

  dum0 = new(18,graphic)  
  
  ;---Attach the polyline
     do i = 0,3,1
 ;     dum0(i) = gsn_add_polyline(wks,plot(i),lonEQ,latEQ,pres0)
     end do 
;delete(i)
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
 ;=====================================================================
;=====================================================================
 
 
  resP                                  = True         ; modify the panel plot
  resP@gsnDraw                          = True      ; don't draw yet
  resP@gsnFrame                         = False        ; don't advance frame yet
  resP@gsnPanelLabelBar    	        = True        ; add common colorbar
  resP@gsnPanelYWhiteSpacePercent      	= 3.0    ; default is 1.0
  resP@gsnPanelXWhiteSpacePercent      	= 0.0    ; default is 1.0
  resP@gsnPanelTop                      = 0.95
  resP@gsnPanelBottom                   = 0.55
  resP@gsnPanelLeft                     = 0.01
  resP@gsnPanelRight                    = 0.99
  resP@lbTitleFontHeightF	        = 0.010 
  resP@lbLabelFontHeightF               = 0.010
 ; resP@lbLabelStride		        = 5
  resP@lbLabelFont   		        = "Helvetica-Bold"     ; label font
  resP@lbTitleString                  	= "Outgoing longwave radiation (W m~S~-2~N~)"
  ;resP@lbTitleString                  	= "SST trend (~S~o~N~C per 35-yr)"
  resP@lbTopMarginF                     = 0.5
  resP@gsnMaximize                      = True         ; large format
  resP@gsnPaperOrientation              = "portrait"   ; force portrait
  resP@gsnLeftString 			= ""
  ;resP@txString          		= "SST trends: 1984-2008"
  resP@txString          		= ""

;*******************************************
 ; resP@gsnPanelCenter   = False                 ; =True .... must move labels
 ; resP@gsnPanelRowSpec  = True                  ; tell panel what order to plot
 ; gsn_panel(wks,plot,(/1,2,2/),resP)
;*******************************************
   
  gsn_panel(wks,plot(0:3),(/2,2/),resP)     ; now draw as one plot
 
;===============================================================
;===============================================================
;===============================================================
;***********************************************
   res_P             = True                        ; panel mods desired
   res_P@gsnDraw              = True       ; don't draw yet
   res_P@gsnFrame             = False        ; don't advance frame yet
   res_P@gsnPanelLabelBar    	        = True        ; add common colorbar
   res_P@gsnPanelYWhiteSpacePercent      = 3.0    ; default is 1.0
   res_P@gsnPanelXWhiteSpacePercent      = 0.0    ; default is 1.0
   res_P@gsnPanelTop                      = 0.50
   res_P@gsnPanelBottom                   = 0.01
   res_P@gsnPanelLeft                     = 0.01
   res_P@gsnPanelRight                    = 0.99
   res_P@lbTitleFontHeightF	        = 0.010 
   res_P@lbLabelFontHeightF               = 0.010
  ; res_P@lbLabelStride		        = 5
   res_P@lbLabelFont   		        = "Helvetica-Bold"     ; label font
   res_P@lbTitleString                  = "Precipitation (mm month~S~-1~N~)"
  ;res_P@lbTitleString                  	= "SST trend (~S~o~N~C per 35-yr)"
   res_P@lbTopMarginF                     = 0.5
   res_P@gsnMaximize                      = True         ; large format
   res_P@gsnPaperOrientation              = "portrait"   ; force portrait
   res_P@gsnLeftString 			= ""
  ;res_P@txString          		= "SST trends: 1984-2008"
  ; res_P@txString          		= "JAS SST trends: 1984-2009"

;   gsn_panel(wks,plot(4:7),(/2,2/),res_P)               ; create panel plots
;==============================================================      ;;===============================================================
;===============================================================
;===============================================================
end

