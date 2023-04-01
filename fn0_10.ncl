

begin
; ==============================================================
; User defined parameters that specify region of globe and
; ==============================================================
  latS   =  -90.
  latN   =  90. 
  lonL   = -180.
  lonR   =  180.

  yrStrt = 1983
  yrLast = 2017

  season = "JAS"    ; choose Dec-Jan-Feb seasonal mean

  p95 = 0.10
  nmos = 12

xlabel = ispan(0,nmos-1,1)
print(xlabel)

 x = fspan(1,35,35)
print(x)


xy_colors_dheating        = (/"deeppink4","red","deepskyblue","darksalmon","black","deeppink4","yellow2","blue","seagreen3","black"/)
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
; ==============================================================
; Open the file: Read only the user specified period
; ==============================================================
;f      = addfile("/home/hnnamchi/work/datasets/rain/annual_arc2_chirps_cmap_cpc_cru_gpcc_gpcp_precl_udel_1983_2017.nc", "r")
  f      = addfile("/home/hnnamchi/work/datasets/rain/precip_arc2_chirps_cmap_cpc_cru_gpcc_gpcp_precl_udel_1983_2017.nc", "r")

  TIME   = f->time
  YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
  iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

  rain    = f->precip(iYYYY,:,:,:)
  printVarSummary(rain)                              ; variable overview
  
   a    = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
   lsdata = a->LSMASK
   lsm  = landsea_mask(lsdata,rain&lat,rain&lon)
   rain = mask(rain,lsm.eq.0,False)
; 
  delete(a)
  delete(lsm)  
delete(f)
delete(TIME)
delete(YYYY)
delete(iYYYY)

;=========================================================================================
;=========================================================================================
;
nyears = dimsizes(rain&time)/nmos
print(nyears)
;
rain_s     = onedtond(ndtooned(rain),(/nyears,nmos,dimsizes(rain&lev),dimsizes(rain&lat),dimsizes(rain&lon)/))
printVarSummary(rain_s)
;
copy_VarCoords(rain(0,:,:,:),rain_s(0,0,:,:,:))                             ; copy coordinate arrays from slp to newslp
rain_s!0 = "time"
rain_s!1 = "month"
printVarSummary(rain_s)
delete(rain)

RAIN = wgt_areaave_Wrap(rain_s(time|:,month|:, lev|:, {lon|-20:10}, {lat |5:10}),1.0, 1.0, 0)	
RAIN&time = x
printVarSummary(RAIN)
;
;
;
;
;
;
;==========================================================================================
;==========================================================================================
;---------------------------------------------------------------------------
; ==============================================================
; Open the file: Read only the user specified period
; ==============================================================
  f      = addfile("/home/hnnamchi/work/datasets/sst/OISST_sst.mnmean.nc", "r")
;f      = addfile("/home/hyacinth/work/datasets/olr/olr.mon.mean.nc", "r")

  TIME   = f->time
  YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
  iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

  sst    = short2flt(f->sst(iYYYY,:,:))
  printVarSummary(sst)                              ; variable overview

delete(f)
delete(TIME)
delete(YYYY)
delete(iYYYY)
 
; ==============================================================
  sst    = lonFlip(sst)
  printVarSummary(sst)                              ; note the longitude coord

; ==============================================================
; compute climatology and Anomalies
; ==============================================================
  xsst   = clmMonTLL(sst)                             ; (12,lat,lon)
  printVarSummary(xsst)

  sst  = calcMonAnomTLL(sst, xsst)                ; (time, lat,lon)
  printVarSummary(xsst)         
  printMinMax(xsst,True)

delete(xsst)
; =================================================================

;=========================================================================================
;------------------------------------------------------------------
; ==============================================================
; compute desired global seasonal mean: month_to_season (contributed.ncl) 
; ==============================================================
 ; SST    = month_to_season(sst, season)
;  SST = month_to_season(sst,season)
 ; SST!0  = "lev"

;=========================================================================================
;=========================================================================================
;
nyears = dimsizes(sst&time)/nmos
print(nyears)
;
sst_s     = onedtond(ndtooned(sst),(/nyears,nmos,dimsizes(sst&lat),dimsizes(sst&lon)/))
printVarSummary(sst_s)
;
copy_VarCoords(sst(0,:,:),sst_s(0,0,:,:))                             ; copy coordinate arrays from slp to newslp
sst_s!0 = "time"
sst_s!1 = "month"
printVarSummary(sst_s)
delete(sst)
;
;
;SST = new((/nyears,nmos,2/),typeof(sst_s),sst_s@_FillValue)
;SST(:,:,1) = wgt_areaave_Wrap(sst_s(time|:,month|:, {lon|-20:0}, {lat | -3:3}),1.0, 1.0, 0)	
;SST(:,:,0) = wgt_areaave_Wrap(sst_s(time|:,month|:, {lon|-120:-90}, {lat | -5:5}),1.0, 1.0, 0)
;SST!2 = "lev"	
;printVarSummary(SST)
;
;
sst_s1 = sst_s
sst_s1    = lonFlip(sst_s)
printVarSummary(sst_s1)                              ; note the longitude coord

;
SST = new((/nyears,nmos,6/),typeof(sst_s),sst_s@_FillValue)
SST(:,:,5) = wgt_areaave_Wrap(sst_s(time|:,month|:, {lon|-20:-10}, {lat | -15:0}),1.0, 1.0, 0)\,
	    -wgt_areaave_Wrap(sst_s(time|:,month|:, {lon|-40:-10}, {lat | -40:-25}),1.0, 1.0, 0)	;na-gti
SST(:,:,4) = wgt_areaave_Wrap(sst_s(time|:,month|:, {lon|-20:0}, {lat | -3:3}),1.0, 1.0, 0)	; atl3
SST(:,:,3) = wgt_areaave_Wrap(sst_s(time|:,month|:, {lon|-90:-80}, {lat | -10:0}),1.0, 1.0, 0)	;nino 1+2
SST(:,:,2) = wgt_areaave_Wrap(sst_s(time|:,month|:, {lon|-150:-90}, {lat | -5:5}),1.0, 1.0, 0)   ; nino3
SST(:,:,1) = wgt_areaave_Wrap(sst_s(time|:,month|:, {lon|-170:-120}, {lat | -5:5}),1.0, 1.0, 0)	;nino3.4
SST(:,:,0) = wgt_areaave_Wrap(sst_s1(time|:,month|:, {lon|160:210}, {lat | -5:5}),1.0, 1.0, 0)	;nino4
SST!2 = "lev"
SST&time = x	
printVarSummary(SST)
;
;
;
;==========================================================================================
;==========================================================================================
  printVarSummary(SST)
 

 ; SST = dim_standardize_n(SST,1,0)  ; normalize

  ;SST = dtrend_msg_n(SST&time,SST,True,False,0)




;---------------------------------------------------
;---------------------------------------------------
pc2 = eof_ts(1,:)
dimZ = dimsizes(SST)
printVarSummary(dimZ)
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
pc2SST = (dim_avg_n_Wrap(pc2P_cases_maps,0)- dim_avg_n_Wrap(pc2N_cases_maps,0))/2.
copy_VarCoords(SST(time|0,month|:,lev|:),pc2SST)                             ; copy coordinate arrays 
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

pc2SSTd = where(abs(pc2SSTd).le.p95,pc2SST,-9999999999999999999.) ; 
print("==============================================================")  
printVarSummary(pc2SSTd)
printMinMax(pc2SSTd,True)
print("==============================================================")


delete(pc2P_cases_maps)
delete(pc2N_cases_maps)

;---------------------------------------------------
;---------------------------------------------------
dimX = dimsizes(RAIN)
printVarSummary(dimX)
;
;
pc2P_cases_mapsX  = new ((/n_pc2P,dimX(1),dimX(2)/),float,RAIN@_FillValue)
printVarSummary(pc2P_cases_mapsX)   
pc2P_cases_mapsX = RAIN(valsP,:,:)
;
;
pc2N_cases_mapsX  = new ((/n_pc2N,dimX(1),dimX(2)/),float,RAIN@_FillValue)
printVarSummary(pc2N_cases_mapsX)                
pc2N_cases_mapsX = RAIN(valsN,:,:)
;
;
pc2RAIN = (dim_avg_n_Wrap(pc2P_cases_mapsX,0)- dim_avg_n_Wrap(pc2N_cases_mapsX,0))/2.
copy_VarCoords(RAIN(time|0,month|:,lev|:),pc2RAIN)                             ; copy coordinate arrays 
printVarSummary(pc2RAIN)
printMinMax(pc2RAIN,True)

do zz=0,8,1
print(pc2RAIN(:,zz))
end do
;print(xxxxxxxxxxxxx)
;
;
;===================================== 
pc2RAINd = pc2RAIN  ; Transfer metdata for plotting sig. values        

pc2RAINd = ttest((dim_avg_n_Wrap(pc2P_cases_mapsX,0)),(dim_stddev_n_Wrap(pc2P_cases_mapsX,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_cases_mapsX,0)),(dim_stddev_n_Wrap(pc2N_cases_mapsX,0))^2,n_pc2N,True, False)
pc2RAINd@long_name = "Probability: difference between means"
printVarSummary(pc2RAINd)

pc2RAINd = where(abs(pc2RAINd).le.p95,pc2RAIN,-9999999999999999999.) ; 
print("==============================================================")  
printVarSummary(pc2RAINd)
printMinMax(pc2RAINd,True)
print("==============================================================")
;
delete(pc2P_cases_mapsX)
delete(pc2N_cases_mapsX)
delete(pc2)
delete(valsP)
delete(valsN)
delete(pc2P_cases)
delete(pc2N_cases)
delete(dimX)
delete(n_pc2P)
delete(n_pc2N)
delete(dimZ)
;
;print(xxxxxxxxxxxxxxxx)


list_vars()
;
;
;-------------------------------------------------------------------------
; ========================================================================
;-------------------------------------------------------------------------
;Remove the linear trends
;& repeat the analysis

SST = dtrend_msg_n(SST&time,SST,True,False,0)
printVarSummary(SST)
;
RAIN = dtrend_msg_n(RAIN&time,RAIN,True,False,0)
printVarSummary(RAIN)
print(RAIN(:,11,0))
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
pc2 = eof_ts_nt(1,:)
dimZ = dimsizes(SST)
printVarSummary(dimZ)
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
copy_VarCoords(SST(time|0,month|:,lev|:),pc2SST_nt)                             ; copy coordinate arrays 
printVarSummary(pc2SST_nt)
;print(xxxxxxxxxxxx)
printMinMax(pc2SST_nt,True)
;
;
;===================================== 
pc2SST_ntd = pc2SST_nt  ; Transfer metdata for plotting sig. values        

pc2SST_ntd = ttest((dim_avg_n_Wrap(pc2P_cases_maps,0)),(dim_stddev_n_Wrap(pc2P_cases_maps,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_cases_maps,0)),(dim_stddev_n_Wrap(pc2N_cases_maps,0))^2,n_pc2N,True, False)
pc2SST_ntd@long_name = "Probability: difference between means"
printVarSummary(pc2SST_ntd)

pc2SST_ntd = where(abs(pc2SST_ntd).le.p95,pc2SST_nt,-9999999999999999999.) ; 
print("==============================================================")  
printVarSummary(pc2SST_ntd)
printMinMax(pc2SST_ntd,True)
print("==============================================================")
;
;
;
;
delete(pc2P_cases_maps)
delete(pc2N_cases_maps)

;---------------------------------------------------
;---------------------------------------------------
dimX = dimsizes(RAIN)
printVarSummary(dimX)
;
;
pc2P_cases_mapsX  = new ((/n_pc2P,dimX(1),dimX(2)/),float,RAIN@_FillValue)
printVarSummary(pc2P_cases_mapsX)   
pc2P_cases_mapsX = RAIN(valsP,:,:)
;
;
pc2N_cases_mapsX  = new ((/n_pc2N,dimX(1),dimX(2)/),float,RAIN@_FillValue)
printVarSummary(pc2N_cases_mapsX)                
pc2N_cases_mapsX = RAIN(valsN,:,:)
;
;
pc2RAIN_nt = (dim_avg_n_Wrap(pc2P_cases_mapsX,0)- dim_avg_n_Wrap(pc2N_cases_mapsX,0))/2.
copy_VarCoords(RAIN(time|0,month|:,lev|:),pc2RAIN_nt)                             ; copy coordinate arrays 
printVarSummary(pc2RAIN_nt)
printMinMax(pc2RAIN_nt,True)

do zz=0,8,1
print(pc2RAIN(:,zz))
end do
;print(xxxxxxxxxxxxx)
;
;
;===================================== 
pc2RAIN_ntd = pc2RAIN_nt  ; Transfer metdata for plotting sig. values        

pc2RAIN_ntd = ttest((dim_avg_n_Wrap(pc2P_cases_mapsX,0)),(dim_stddev_n_Wrap(pc2P_cases_mapsX,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_cases_mapsX,0)),(dim_stddev_n_Wrap(pc2N_cases_mapsX,0))^2,n_pc2N,True, False)
pc2RAIN_ntd@long_name = "Probability: difference between means"
printVarSummary(pc2RAIN_ntd)

pc2RAIN_ntd = where(abs(pc2RAIN_ntd).le.p95,pc2RAIN_nt,-9999999999999999999.) ; 
print("==============================================================")  
printVarSummary(pc2RAIN_ntd)
printMinMax(pc2RAIN_ntd,True)
print("==============================================================")
;
delete(pc2P_cases_mapsX)
delete(pc2N_cases_mapsX)
delete(pc2)
delete(valsP)
delete(valsN)
delete(pc2P_cases)
delete(pc2N_cases)
delete(dimX)
delete(n_pc2P)
delete(n_pc2N)
delete(dimZ)
;

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
  wks = gsn_open_wks("eps","fn0_10")         ; send graphics to PNG file
  plot = new(4,graphic)                ; create graphic array
                                          ; only needed if paneling
  plotS = new(4,graphic)                ; create graphic array
  plotR = new(4,graphic)                ; create graphic array
; EOF patterns
   res               = True                        ; plot mods desired
   res@gsnDraw       = False                       ; do not draw
   res@gsnFrame      = False                       ; do not advance frame
   res@tiMainString  = ""                       ; title
   res@tiXAxisFontHeightF = 0.017
   res@tiYAxisFontHeightF = 0.015
   res@tiYAxisString = "SST anomaly (K)"                  ; yaxis
   ; res@tiYAxisString = "SST (~S~o~N~C)"                  ; yaxis
   ;res@tiYAxisAngleF  =  270.
   res@tmXBLabelFontHeightF = 0.015
   res@tmYLLabelFontHeightF = 0.015
   res@trYLog              = False                ; log scaling
   res@trXLog              = False               ; log scaling
   ;res@trXMinF             = 1940.                 ; manually set lower limit
   ;res@trXMaxF             = 2020.                ;   "          upper
  res@trYMinF             =   -0.9                 ; manually set lower limit
  res@trYMaxF             =    0.91          

   res@trXMinF             =  0.                 ; manually set lower limit
   res@trXMaxF             =  11.                 ;   "          upper
  ; res@gsnYRefLineThicknesses = (/1/)
  ; res@gsnYRefLineDashPatterns = (/0./)
   ;res@xyLineColors        = (/"springgreen4","springgreen","transparent"/)
   res@xyLineColors        = xy_colors_dheating 
   res@tmXTBorderOn            =  True
   res@tmXTOn                  =  True
   res@xyMarkers		= (/16,16,7,8,9,12,13,15,16,0/)
   res@xyMarkerColors		= res@xyLineColors
      
   res@tmYLFormat = "@*+^sg"	; use "e" symbol, don't force 0's (see documentation)
   res@gsnYRefLine           = (/0./) 
   res@gsnYRefLineDashPattern = 2

   ;res@tmYLMode        = "Explicit"	
   ;res@tmYLValues      = (/"-0.5","0.0","0.5","1.0"/)
   ;res@tmYLLabels      =  res@tmYLValues
   ;res@tmYLMinorValues = fspan(-1.0,1.0,11)
   ;print(res@tmYLMinorValues)
   
   res@vpWidthF                = 0.70
   res@vpHeightF               = 0.50
   ;res@tmXBMajorOutwardLengthF = 0.0               ; draw tickmarks inward
   ;res@tmXBMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
   ;res@tmYLMajorOutwardLengthF = 0.0               ; draw tickmarks inward
   ;res@tmYLMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  ; res@tmXTMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  ; res@tmXTMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
   res@tmYRMajorOutwardLengthF = 0.0               ; draw tickmarks inward
   res@tmYRMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
   res@xyMarkLineMode 	       =  "Lines"
   res@xyLineThicknesses   = (/1.,1.,1.,1.,1.,1.,1.,1.,1.,5./)       ; Define line thicknesses 
   res@xyDashPatterns      = (/1.,0.,0.,0.,0.,0.,0.,0.,0.,0./)           ; Dash patterns 
   res@tmYLLabelFontColor = "foreground"   ; and right axes are same.
   res@tiYAxisFontColor  = "foreground"
   ;res@tmBorderLineColor = "deepskyblue"
   ;res@tmYLMajorLineColor = "red" ; YR axis uses YL resources, can
   ;res@tmYLMinorLineColor = "red" ; change by setting tmYUseLeft = False 
   ;res@tmBorderLineColor =  "red"
 
   res@tmXBMode = "Explicit"
   res@tmXBValues = (/"0", "1","2","3","4","5","6","7","8","9","10","11"/)
   ;res@tmXBLabels = (/"J", "F","M","A","M","J","J","A","S","O","N","D"/)
   res@tmXBLabels = (/"Jan", "Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"/)
   ;res@tmXBLabels = (/"-5", "-4","-3","-2","-1","0","+1","+2","+3","+4","+5","+6"/)
   
   ;res@tmXBMinorOn          = False                ; Turn off x-axis (bottom) minor ticks
   ;res@tmXTMinorOn          = False                ; Turn off x-axis (bottom)minor ticks
   ;res@tmXTOn               = False                ; Turn off x-axis (top) major ticks
   ;res@tmYRMinorOn          = False                ; Turn off y-axis (right) minor ticks
   ;res@tmYLMinorOn          = False                ; Turn off y-axis (left) minor ticks
   ;res@tmYROn               = False                ; Turn off y-axis (right) major ticks

  ;===legends
   ;===legends
   res@pmLegendDisplayMode    = "Always"            ; turn on legend
   res@pmLegendSide           = "Top"               ; Change location of 
   res@pmLegendParallelPosF   = 0.90                 ; move units right
   res@pmLegendOrthogonalPosF = -0.45                ; move units down
   res@pmLegendWidthF         = 0.08                ; Change width and
   res@pmLegendHeightF        = 0.15                ; height of legend.
   res@lgLabelFontHeightF     = 0.012                 ; change font height
   res@lgTitleOn              = True               ; turn on legend title
   res@lgTitleString          = "~F22~SST indices"           ; create legend title
   res@lgTitleFontHeightF     = .010                ; font of legend title
   res@lgPerimOn              = True               ; turn off box around
   ;res@xyExplicitLegendLabels = (/"UDEL","PRECL","GPCP","GPCC","CRU","CPC","CMAP","CHIRPS","ARC2"/)         ; explicit labels   
   res@xyExplicitLegendLabels = (/"Nino4","Nino3.4","Nino3","Nino1+2","Atl3","SAOD","GPCC","GPCP","PRECL","UDEL"/)         ; explicit labels

;==================================================================================

 do ii = 0,5,1		;flight the Nino4 sign
          if(ii.lt.3)then
           pc2SST(lev|ii,month|:) = pc2SST(lev|ii,month|:)
 	   pc2SST_nt(lev|ii,month|:) = pc2SST_nt(lev|ii,month|:)

	   pc2SSTd(lev|ii,month|:) = pc2SSTd(lev|ii,month|:)
 	   pc2SST_ntd(lev|ii,month|:) = pc2SST_ntd(lev|ii,month|:)
          end if
end do
 
  plotA0  =  gsn_csm_xy(wks,xlabel,pc2SST(lev|:,month|:),res)
  plotA1  =  gsn_csm_xy(wks,xlabel,pc2SST_nt(lev|:,month|:),res)
;
  ;res@xyMarkLineMode 	       =  "MarkLines"
  res@xyMarkLineMode 	       =  "Markers"
  plotB0  =  gsn_csm_xy(wks,xlabel,pc2SSTd(lev|:,month|:),res)
  plotB1  =  gsn_csm_xy(wks,xlabel,pc2SST_ntd(lev|:,month|:),res)

  overlay(plotA0,plotB0)
  plot(0) = plotA0

  overlay(plotA1,plotB1)
  plot(1) = plotA1

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
   res@pmLegendDisplayMode    = "Always"            ; turn on legend
   res@pmLegendSide           = "Top"               ; Change location of 
   res@pmLegendParallelPosF   = 0.92                 ; move units right
   res@pmLegendOrthogonalPosF = -0.45                ; move units down
   res@pmLegendWidthF         = 0.08                ; Change width and
   res@pmLegendHeightF        = 0.145                ; height of legend.
   res@lgLabelFontHeightF     = 0.008                 ; change font height
   res@lgTitleOn              = True               ; turn on legend title
   res@lgTitleString          = "~F22~Datasets"           ; create legend title
   res@lgTitleFontHeightF     = .010                ; font of legend title
   res@lgPerimOn              = True              ; turn off box around
   ;res@xyExplicitLegendLabels = (/"UDEL","PRECL","GPCP","GPCC","CRU","CPC","CMAP","CHIRPS","ARC2"/)         ; explicit labels   
   res@xyExplicitLegendLabels = (/"ARC2","CHIRPS","CMAP","CPC","CRU","GPCC","GPCP","PRECL","UDEL","Ensemble"/)         ; explicit labels
xy_colors_dheating        = (/"red","slateblue","deepskyblue","darksalmon","black","deeppink4","yellow2","blue","seagreen3","black"/)
res@trYMaxF             =   60.
res@trYMinF             =   -20.                 ; manually set lower limit
res@xyLineColors        = xy_colors_dheating 
res@xyMarkerColors	= res@xyLineColors
res@xyMarkers		= (/4,6,7,8,9,12,13,15,16,0/)
res@tiYAxisString = "Precipitation (mm month~S~-1~N~)"                  ; yaxis
res@xyMarkLineMode 	       =  "Lines"

m_pc2RAIN = dim_avg_n_Wrap(pc2RAIN,1)
print(m_pc2RAIN)

m_pc2RAIN_nt = dim_avg_n_Wrap(pc2RAIN_nt,1)
print(m_pc2RAIN_nt)


plotA2  =  gsn_csm_xy(wks,xlabel,pc2RAIN(lev|:,month|:),res)    
plotA3  =  gsn_csm_xy(wks,xlabel,pc2RAIN_nt(lev|:,month|:),res)     

;res@xyMarkLineMode 	       =  "MarkLines"
res@xyMarkLineMode 	       =  "Markers"
plotB2  =  gsn_csm_xy(wks,xlabel,pc2RAINd(lev|:,month|:),res)
plotB3  =  gsn_csm_xy(wks,xlabel,pc2RAIN_ntd(lev|:,month|:),res)
overlay(plotA2,plotB2)
plot(2) = plotA2

overlay(plotA3,plotB3)
plot(3) = plotA3
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;---------------------------------------------------------------------
var_names = (/"Trend + Variability","No trend"/)
printVarSummary(var_names)
print(var_names)

  txres               = True         ; Text resources
  txres@txFontHeightF = 0.015
  txres@txJust        = "CenterLeft"
  txres@txFont                = "Helvetica-Bold"
  txres@txAngleF      =  0.

  labels0  = var_names
  xpos0    = fspan(0.20, 0.65,dimsizes(var_names))

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
  txres5@txFontHeightF = 0.025   ; Use same font height as left axis
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
tt_p0 = new(4,graphic)                ; create graphic array ; only needed if paneling
tt_p1 = new(4,graphic)
;---Attach the polyline
     do i = 0,3,1
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
  resP@gsnPanelLabelBar    	        = False        ; add common colorbar
  resP@gsnPanelYWhiteSpacePercent      	= 0.0    ; default is 1.0
  resP@gsnPanelXWhiteSpacePercent      	= 0.0    ; default is 1.0
  resP@gsnPanelTop                      = 1.0
  resP@gsnPanelBottom                   = 0.15
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
   res_P@lbTitleString                  = "EOF2 (mm month~S~-1~N~)"
  ;res_P@lbTitleString                  	= "SST trend (~S~o~N~C per 35-yr)"
   res_P@lbTopMarginF                     = 0.5
   res_P@gsnMaximize                      = True         ; large format
   res_P@gsnPaperOrientation              = "portrait"   ; force portrait
   res_P@gsnLeftString 			= ""
  ;res_P@txString          		= "SST trends: 1984-2008"
  ; res_P@txString          		= "JAS SST trends: 1984-2009"

 ;  gsn_panel(wks,plot(4:7),(/2,2/),res_P)               ; create panel plots
;==============================================================      ;;===============================================================
;===============================================================
;===============================================================
end

