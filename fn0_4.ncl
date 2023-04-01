; ==============================================================
; eof_1.ncl
;
; Concepts illustrated:
;   - Calculating EOFs
;   - Drawing a time series plot
;   - Using coordinate subscripting to read a specified geographical region
;   - Rearranging longitude data to span -180 to 180
;   - Calculating symmetric contour intervals
;   - Drawing filled bars above and below a given reference line
;   - Drawing subtitles at the top of a plot
;   - Reordering an array
; ==============================================================
; NCL V6.4.0 has new functions eofunc_n_Wrap and 
; eofunc_ts_n_Wrap that allow you to calculate the EOFs without 
; first having to first reorder the data. See eof_1_640.ncl.
; ==============================================================
; Calculate EOFs of the Sea Level Pressure over the North Atlantic.
; ==============================================================
; The rain.mon.mean file can be downloaded from:
; http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis.surface.html
; ==============================================================
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
; ==============================================================
; User defined parameters that specify region of globe and
;==============================================================
r = (/0.93,0.94,0.93,0.89,0.90,0.82,0.90,0.90,0.87,0.87,0.87,0.84,0.88/)	;
d = (/2.43,2.46,2.48,2.20,2.22,1.86,2.23,2.27,2.09,2.02,1.97,1.84,2.19/)	;scaled according to years-length
r2= (/0.49,0.50,0.51,0.40,0.41,0.29,0.41,0.43,0.36,0.34,0.32,0.28,0.40/)
m_r = avg(r)
d_r = stddev(r)
;
m_d = avg(d)
d_d = stddev(d)
;
m_r2= avg(r2)
d_r2 = stddev(r2)
;
print(m_r)
print(d_r)
print(m_d) 
print(d_d)
print(m_r2)
print(d_r2)
;print(xxxxxxxxxx)
;

delete(m_r)
delete(d_r)
delete(m_d) 
delete(d_d)
delete(m_r2)
delete(d_r2)

delete(r)
delete(d)
delete(r2)
;print(xxxxxxxx)
;==============================================================
  latS   =   0.
  latN   =  20. 
  lonL   = -20.
  lonR   =  20.

  yrStrt = 1995
  yrLast = 2017

  season = "JAS"    ; choose Dec-Jan-Feb seasonal mean

  neof   = 2        ; number of EOFs
  optEOF = True       
  optEOF@jopt = 0   ; This is the default; most commonly used; no need to specify.
;;optEOF@jopt = 1   ; **only** if the correlation EOF is desired

  optETS = False

nmos = 12

p95 = 0.05
lag = 1
mxlag = 5

dlen = (yrLast-yrStrt) + 1

; ==============================================================
; Open the file: Read only the user specified period
; ==============================================================
;f      = addfile("/home/hyacinth/work/datasets/rain/annual_arc2_chirps_cmap_cpc_cru_gpcc_gpcp_precl_udel_1983_2017.nc", "r")
  f      = addfile("/home/hyacinth/work/datasets/rain/precip_arc2_chirps_cmap_cpc_cru_gpcc_gpcp_precl_udel_1983_2017.nc", "r")

  TIME   = f->time
  YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
  iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

  rain    = f->precip(iYYYY,:,:,:)
  printVarSummary(rain)                              ; variable overview
  ;print(xxxxxxxxxxx)

 
   a    = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
   lsdata = a->LSMASK
   lsm  = landsea_mask(lsdata,rain&lat,rain&lon)
   rain = mask(rain,lsm.eq.0,False)
; 
  delete(a)
  delete(lsm)  
  

; ==============================================================
; dataset longitudes span 0=>357.5
; Because EOFs of the North Atlantic Oscillation are desired
; use the "lonFlip" (contributed.ncl) to reorder 
; longitudes to span -180 to 177.5: facilitate coordinate subscripting
; ==============================================================
  ;rain    = lonFlip( rain )
 ; printVarSummary(rain)                              ; note the longitude coord
;print(xxxxxxxxxx)
;===============================================================================================================
;===============================================================================================================

;=========================================================================================
;------------------------------------------------------------------
; ==============================================================
; compute desired global seasonal mean: month_to_season (contributed.ncl) 
; ==============================================================
  RAIN    = month_to_season (rain, season)
  nyrs   = dimsizes(RAIN&time)
  printVarSummary(RAIN)

;  RAIN = dtrend_msg_n(RAIN&time,RAIN,True,False,0)
; =================================================================
; create weights:  sqrt(cos(lat))   [or sqrt(gw) ]
; =================================================================
  rad    = 4.*atan(1.)/180.
  clat   = f->lat           
  clat   = sqrt(cos(rad*clat))                 ; gw for gaussian grid

; =================================================================
; weight all observations 
; =================================================================
  wRAIN   = RAIN                                   ; copy meta data
  wRAIN   = RAIN*conform(RAIN,clat,2)
  wRAIN@long_name = "Wgt: "+wRAIN@long_name
;print(xxxxxxxxxxxxx)
; =================================================================
; Reorder (lat,lon,time) the *weighted* input data
; Access the area of interest via coordinate subscripting
; =================================================================
  xw     = wRAIN(lev|:,{lat|latS:latN},{lon|lonL:lonR},time|:)
 
  eof      = eofunc_Wrap(xw, neof, optEOF) 
  eof_ts   = eofunc_ts_Wrap (xw, eof, optETS)
 
  
   ;ev_rot = eofunc_varimax_Wrap(eof, 1)     
   ;eof_ts   = eofunc_ts_Wrap (xw,ev_rot, optETS)
 
  printVarSummary(eof)                         ; examine EOF variables
  printVarSummary(eof_ts)
;print(xxxxxxxxxxxxxx)

do ii = 0,neof-1,1		;common pattern for both PCs
          if(ii.eq.1)then
           eof_ts(ii,:) = eof_ts(ii,:)*-1
          end if
end do
; =================================================================
; Normalize time series: Sum spatial weights over the area of used
; =================================================================
  dimxw  = dimsizes(xw)
  mln    = dimxw(1)
  sumWgt = mln*sum(clat({lat|latS:latN}))
  eof_ts = eof_ts/sumWgt

  eof_ts = dim_standardize_n(eof_ts,1,1)  ; new variable

;---------------------------------------------------------------
rp = fspan(yrStrt,yrLast,dlen)
;rp = dim_standardize_n(rp,0,0)  ; new variable
print(rp)

;---------------------------------
 rc =  regline_stats(rp,eof_ts(0,:)) ; linear regression coef
 rc = rc*dlen
 print(rc)
delete(rc)
delete(rp)
print(xxxxxxx)
;---------------------------------
;---------------------------------------------------------------
;save the pc time series
system("/bin/rm -f eof_ts.nc")   ; remove any pre-existing file
ncdf = addfile("eof_ts.nc" ,"c")  ; open output netCDF file
ncdf->eof_ts  = eof_ts                          ;       


; =================================================================
d_RAIN = regCoef(eof_ts(evn|:,time|:),RAIN(lev|:,lat|:,lon|:,time|:))
printVarSummary(d_RAIN)
copy_VarCoords(eof,d_RAIN)                             ; copy coordinate arrays from slp to newslp
printVarSummary(d_RAIN)

;==============================================================
;==============================================================

;--------------test for significance
 d_RAINd = d_RAIN
 
 df = d_RAIN

 lag_ts = esacr(eof_ts(evn|:,time|:),mxlag) ; acr(nlat,nlon,mxlat+1)
 printVarSummary(lag_ts)
 
 lag_ts_map   = esacr(RAIN(lev|:,lat|:,lon|:,time|:),mxlag) ; acr(nlat,nlon,mxlat+1)
 printVarSummary(lag_ts_map)

 tval = onedtond(d_RAIN@tval,dimsizes(d_RAIN))
      
    do ne = 0,neof-1,1
           df(ne,:,:,:) = floattointeger(dimsizes(RAIN(:,0,0,0))*(1. -(lag_ts(ne,lag)*lag_ts_map(:,:,:,lag)))\
        /(1. + (lag_ts_map(:,:,:,lag)*lag_ts(ne,lag)))) 
    end do
   delete(ne)
   printVarSummary(tval)
   printVarSummary(df)
   b = tval    ; b must be same size as tval (and df)
   b = 0.5
   prob = betainc(df/(df+tval^2),df/2.0,b)       ; prob(nlat,nlon)


   
   prob@long_name   = "regression coefficient"
   prob@long_name = "probability"
   printVarSummary(prob)


d_RAINd = where(abs(prob).lt.p95,d_RAINd,d_RAINd@_FillValue) ; Significant TEMP
printVarSummary(d_RAINd)

delete([/tval,df,prob,b/])
delete(lag_ts)
delete(lag_ts_map)
;delete(RAIN)

; =================================================================

;*******************************************
; North significance test: any pcvar, eval_transpose, eval can be used
;*******************************************
  print("---")
  print("--- eofunc_north ---")
  print("---")
  
  dimp   = dimsizes(RAIN)
  ntim   = dimp(0)                                            ; max # eigenvalues possible
  
  prinfo = True
  sig    = eofunc_north(eof@pcvar, ntim, prinfo)   
                                                         
  print("---")
;*******************************************
;  Create a 'time' axis for plot
;*******************************************
; =================================================================
; Extract the YYYYMM from the time coordinate 
; associated with eof_ts [same as RAIN&time] 
; =================================================================

  yyyymm = cd_calendar(eof_ts&time,-2)/100  
;;yrfrac = yyyymm_to_yyyyfrac(yyyymm, 0.0); not used here
;==================================================================
dMEAN_RAIN = dim_avg_n_Wrap(d_RAIN,1)
printVarSummary(dMEAN_RAIN)
;
dMEAN_RAINd = dim_avg_n_Wrap(d_RAINd,1)
printVarSummary(dMEAN_RAINd)
;
dSTD_RAIN = dim_stddev_n_Wrap(d_RAIN,1)
printVarSummary(dSTD_RAIN)
;============================================================
;============================================================
; PLOTS
;============================================================
  wks = gsn_open_wks("eps","fn0_4")         ; send graphics to PNG file
  plot = new(18,graphic)                ; create graphic array
                                          ; only needed if paneling
  plotS = new(18,graphic)                ; create graphic array
; EOF patterns

  res                      = True         
  res@gsnDraw              = False        ; don't draw yet
  res@gsnFrame             = False        ; don't advance frame yet
  res@cnLevelSelectionMode = "ManualLevels"  ; set manual contour levels
  res@cnMinLevelValF       = -40.            ; set min contour level
  res@cnMaxLevelValF       =  40.             ; set max contour level
  res@cnLevelSpacingF      =  4.            ; set contour spacing  
 
  res@mpFillOn             = False        ; turn off map fill
  res@mpMinLatF            = latS         ; zoom in on map
  res@mpMaxLatF            = latN
  res@mpMinLonF            = lonL
  res@mpMaxLonF            = lonR
  ;res@pmTickMarkDisplayMode = "Always"
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
      
  res@mpGeophysicalLineColor  = "grey" 
  res@mpFillDrawOrder      = "preDraw"

  res@gsnAddCyclic         = True
  res@cnFillOn             = True         ; turn on color fill
  res@cnLinesOn            = False        ; True is default
  res@cnLineLabelsOn       = False        ; True is default
  res@cnMissingValFillColor = "grey" ; comment this line out 
  ;res@cnFillPalette        = "BlueWhiteOrangeRed"  
  res@mpOceanFillColor        = "white"
  res@mpGeophysicalLineColor  = "grey" 
  cmap = read_colormap_file("ncl_default")
  ;cmap = read_colormap_file("cmp_b2r")
  cmap_r = cmap(::-1,:)
  res@cnFillPalette = cmap_r ; for the reverse color map 
  
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

  res@vpHeightF 	  = 0.80        ; Changes the aspect ratio
  res@vpWidthF 		  = 0.60
  res@gsnCenterStringFontHeightF   = 0.025
 ; res@vpXF      = 0.30        ; change start locations
 ; res@vpYF      = 0.75        ; the plot
  

 
  res@tmXBMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  res@tmXBMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  res@tmYLMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  res@tmYLMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  res@tmXTMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  res@tmXTMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  res@tmYRMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  res@tmYRMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
;=============================================================================
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
;-----------------------------------------------------------------------------
;======================================================
;==============================================================
;=========================================================;===============
;===============
;-----------------------------------------------------------------------------
  res1                      =   True
  res1@gsnDraw              = False        ; don't draw yet
  res1@gsnFrame             = False        ; don't advance frame yet
  res1@cnLevelSelectionMode = "ManualLevels"  ; set manual contour levels
  res1@cnMinLevelValF       =  -300.            ; set min contour level
  res1@cnMaxLevelValF       =  300.             ; set max contour level
  res1@cnLevelSpacingF      =  30.            ; set contour spacing  
  res1@gsnAddCyclic         = False   
  res1@cnLinesOn            = False       ; True is default
  res1@cnLineLabelsOn       = False        ; True is default
  res1@cnInfoLabelOn        = False
  res1@gsnRightString   = ""
  res1@gsnLeftString   = ""
  res1@cnFillScaleF        = 1.5         ; add extra density
  ;res1@cnLineLabelDensityF =  -10.
  res1@cnFillDotSizeF       = 0.0001            ; increase dot size of contours
;-----------------------------------------------------------------------------
  res2                      =   True
  res2@gsnDraw              = False        ; don't draw yet
  res2@gsnFrame             = False        ; don't advance frame yet
  res2@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
  res2@cnLevels    	    = (/0.2/)   ; set levels
  res2@cnMonoLineColor	    = True
  res2@cnLineColor	    = "white"
  res2@gsnAddCyclic         = False   
  res2@cnLinesOn            = True       ; True is default
  res2@cnLineLabelsOn       = False        ; True is default
  res2@cnInfoLabelOn        = False
  res2@gsnRightString   = ""
  res2@gsnLeftString   = ""
  res2@cnFillScaleF        = 2.         ; add extra density
  ;res2@cnLineLabelDensityF =  -10.
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
  opt = True
  opt@gsnShadeFillType = "pattern"        ; color is the default
  ;opt@gsnShadeLow = 17                     ; use fill pattern #4
  opt@gsnShadeHigh = 17                  ; use pattern #2   
  ;opt@gsnShadeMid = 2   
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
 res@gsnLeftStringFontHeightF   = 0.025
 res@gsnCenterString  = ""
 res@gsnRightString  = ""  
 res@gsnLeftString  = ""  
 res@tmYLLabelsOn          = True      ;no lon ticks
 res@tmXBLabelsOn          = True      ;no lon ticks
 
   
  DATA_NAMES = (/"ARC2","CHIRPS","CMAP","CPC","CRU","GPCC","GPCP","PRECL","UDEL"/)
  res@gsnAddCyclic         = False
  res@gsnLeftStringOrthogonalPosF = -0.95
  res@gsnLeftStringParallelPosF =   0.05
  res@gsnLeftStringFontColor = "grey25"
 
do n=0,8,1
     res@gsnLeftString  = DATA_NAMES(n)
  ;  if(n.eq.4)
  ;    res@trXTensionF = 10.
  ;  else
  ;   res@trXTensionF = 2.
  ; end if
   ;
;plot(n) = gsn_csm_contour_map_ce(wks,d_RAIN(2,n,:,:),res)

   
   plot(n) = gsn_csm_contour_map_ce(wks,d_RAIN(0,n,:,:),res)
   plotS(n) = gsn_csm_contour(wks,d_RAINd(0,n,:,:),res1)
   plotS(n) = gsn_contour_shade(plotS(n),p95,d_RAIN@_FillValue,opt)

  overlay(plot(n),plotS(n))
  plot(n) = plot(n)

end do

;delete(n)
;
do n=0,8,1
     res@gsnLeftString  = DATA_NAMES(n)
     plot(n+9) = gsn_csm_contour_map_ce(wks,d_RAIN(1,n,:,:),res)
     plotS(n+9) = gsn_csm_contour(wks,d_RAINd(1,n,:,:),res1)
     plotS(n+9) = gsn_contour_shade(plotS(n+9),p95,d_RAIN@_FillValue,opt)

  overlay(plot(n+9),plotS(n+9))
  plot(n+9) = plot(n+9)

end do

delete(n)

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;---------------------------------------------------------------------
var_names = (/"Multi-data mean","Multi-data standard deviations"/)
printVarSummary(var_names)
print(var_names)

  txres               = True         ; Text resources
  txres@txFontHeightF = 0.017
  txres@txJust        = "CenterLeft"
  txres@txFont                = "Helvetica-Bold"
  txres@txAngleF      =  0.

  labels0  = var_names
  xpos0    = fspan(0.05, 0.50,dimsizes(var_names))

; do i = 0,dimsizes(labels0)-1,1
;     gsn_text_ndc(wks,labels0(i),xpos0(i),0.97,txres)
;  end do
;delete(i)
;delete(txres)
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
  txres5@txFontHeightF = 0.030   ; Use same font height as left axis
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
tt_p0 = new(18,graphic)                ; create graphic array ; only needed if paneling
;---Attach the polyline
     do i = 0,17,1
      tt_p0(i) = gsn_add_annotation(plot(i),create_tt(i),amres5)
     end do 
 delete(i)
;
;
;===============================================================
;==============================================================
  latEQ = (/ 10.,  10.,  10.,   10., 10./)
  lonEQ = (/-20., 20., 20., -20.,-20./)

;---Resources for the polyline
  pres0                  = True           ; polyline mods desired
  pres0@gsLineThicknessF = 0.5            ; line thickness   
  pres0@gsLineColor      = "black"         ; color of lines
  pres0@gsLineDashPattern = 14
  pres0@tfPolyDrawOrder   = "postDraw"

  dum0 = new(18,graphic)  
  
  ;---Attach the polyline
     do i = 0,17,1
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
  resP@gsnPanelTop                      = 1.0
  resP@gsnPanelBottom                   = 0.51
  resP@gsnPanelLeft                     = 0.01
  resP@gsnPanelRight                    = 0.99
  resP@lbTitleFontHeightF	        = 0.010 
  resP@lbLabelFontHeightF               = 0.010
  resP@lbLabelStride		        = 5
  resP@lbLabelFont   		        = "Helvetica-Bold"     ; label font
  resP@lbTitleString                  	= "Extended-EOF1 (mm month~S~-1~N~)"
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
   
  gsn_panel(wks,plot(0:8),(/3,3/),resP)     ; now draw as one plot
 
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
   res_P@lbLabelStride		        = 5
   res_P@lbLabelFont   		        = "Helvetica-Bold"     ; label font
   res_P@lbTitleString                  = "Extended-EOF2 (mm month~S~-1~N~)"
  ;res_P@lbTitleString                  	= "SST trend (~S~o~N~C per 35-yr)"
   res_P@lbTopMarginF                     = 0.5
   res_P@gsnMaximize                      = True         ; large format
   res_P@gsnPaperOrientation              = "portrait"   ; force portrait
   res_P@gsnLeftString 			= ""
  ;res_P@txString          		= "SST trends: 1984-2008"
  ; res_P@txString          		= "JAS SST trends: 1984-2009"

   gsn_panel(wks,plot(9:17),(/3,3/),res_P)               ; create panel plots
;==============================================================      ;;===============================================================
;===============================================================
;===============================================================
end

