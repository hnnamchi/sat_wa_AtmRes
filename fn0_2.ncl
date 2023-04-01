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
; ==============================================================
  latS   =   0.
  latN   =  20. 
  lonL   = -20.
  lonR   =  20.

  yrStrt = 1983
  yrLast = 2017

  season = "JAS"    ; choose Dec-Jan-Feb seasonal mean

 nmos = 12
xlabel = ispan(0,nmos-1,1)
print(xlabel)
 
xy_colors_dheating        = (/"red","slateblue","deepskyblue","darksalmon","black","deeppink4","yellow2","blue","seagreen3","black"/)
;xy_colors_thermocline        = (/"blue","yellow2","red","slateblue","deepskyblue","black"/)
;xy_colors_thermocline        = (/"red","yellow2","deepskyblue","blue","deeppink4","black"/)



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
;===============================================================================================================
;===============================================================================================================
 MM = clmMonTLLL(rain)       ; monthly climatology (12,nlev,nlat,mlon)
 printVarSummary(MM)
 ;
 m_index = wgt_areaave_Wrap(MM(month|:,lev|:, {lon|lonL:lonR}, {lat |latS:latN}),1.0, 1.0, 0)	;June 
 printVarSummary(m_index)
 delete(MM)
 
;------------------------------
 DD = stdMonTLLL(rain)       ; monthly climatology (12,nlev,nlat,mlon)
 printVarSummary(DD)
 ;
 d_index = wgt_areaave_Wrap(DD(month|:,lev|:, {lon|lonL:lonR}, {lat |latS:latN}),1.0, 1.0, 0)	;June 
 printVarSummary(d_index)
 delete(DD)
 delete(rain)
 
;=========================================================================================
;=========================================================================================
x = new((/nmos,10/),float,m_index@_FillValue)
x(:,0:8) = (/m_index/)	
x(:,9) = dim_avg_n(m_index,1)
printVarSummary(x)
print(x(:,9))
delete(m_index)
m_index = x
delete(x)
m_index!0 = "month"
m_index!1 = "lev"
printVarSummary(m_index)

mMax = dim_max_n(m_index,1)   ;==>  qMax(3,5)
print(mMax)
print(m_index(:,0))
;print(xxxxxxxxxxxxx)
;
;
x = new((/nmos,10/),float,d_index@_FillValue)
x(:,0:8) = (/d_index/)	
x(:,9) = dim_avg_n(d_index,1)
printVarSummary(x)
print(x(:,9))
delete(d_index)
d_index = x
delete(x)
d_index!0 = "month"
d_index!1 = "lev"
printVarSummary(d_index)

dMax = dim_stddev_n(m_index,1)   ;==>  qMax(3,5)
print(dMax)
;print(d_index(:,9))





;print(xxxxxxxxxxxxx)
;===============================================================
;============================================================
;============================================================
; PLOTS
;============================================================

  wks = gsn_open_wks("eps","fn0_2")         ; send graphics to PNG file
  plot = new(2,graphic)                ; create graphic array
                                          ; only needed if paneling
  plotS = new(2,graphic)                ; create graphic array
; EOF patterns

   res               = True                        ; plot mods desired
   res@gsnDraw       = False                       ; do not draw
   res@gsnFrame      = False                       ; do not advance frame
   res@tiMainString  = ""                       ; title
   res@tiXAxisFontHeightF = 0.017
   res@tiYAxisFontHeightF = 0.015
   res@tiYAxisString = "Mean (mm month~S~-1~N~)"                  ; yaxis
   res@tiXAxisString = ""                  ; yaxis
  ; res@tiYAxisString = "SST (~S~o~N~C)"                  ; yaxis
   ;res@tiYAxisAngleF  =  270.
   res@tmXBLabelFontHeightF = 0.015
   res@tmYLLabelFontHeightF = 0.015
   res@trYLog              = False                ; log scaling
   res@trXLog              = False               ; log scaling
   ;res@trXMinF             = 1940.                 ; manually set lower limit
   ;res@trXMaxF             = 2020.                ;   "          upper
  res@trYMinF             =    0.                 ; manually set lower limit
  res@trYMaxF             =   180.           

   res@trXMinF             =  0.                 ; manually set lower limit
   res@trXMaxF             =  11.                 ;   "          upper
  ; res@gsnYRefLineThicknesses = (/1/)
  ; res@gsnYRefLineDashPatterns = (/0./)
   ;res@xyLineColors        = (/"springgreen4","springgreen","transparent"/)
   res@xyLineColors        = xy_colors_dheating 
   res@tmXTBorderOn            =  True
   res@tmXTOn                  =  True
   res@xyMarkLineMode 	       =  "MarkLines"
   res@xyMarkers		= (/4,6,7,8,9,12,13,15,16,0/)
   res@xyMarkerColors		= res@xyLineColors
      
   res@tmYLFormat = "@*+^sg"	; use "e" symbol, don't force 0's (see documentation)
  ; res@gsnXRefLine           = (/5./) 
  ; res@gsnYRefLineDashPattern = 16

   ;res@tmYLMode        = "Explicit"	
   ;res@tmYLValues      = (/"-0.5","0.0","0.5","1.0"/)
   ;res@tmYLLabels      =  res@tmYLValues
   ;res@tmYLMinorValues = fspan(-1.0,1.0,11)
   ;print(res@tmYLMinorValues)
   
   res@vpWidthF                = 0.70
   res@vpHeightF               = 0.35
   ;res@tmXBMajorOutwardLengthF = 0.0               ; draw tickmarks inward
   ;res@tmXBMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
   ;res@tmYLMajorOutwardLengthF = 0.0               ; draw tickmarks inward
   ;res@tmYLMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  ; res@tmXTMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  ; res@tmXTMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
   res@tmYRMajorOutwardLengthF = 0.0               ; draw tickmarks inward
   res@tmYRMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
 
   res@xyLineThicknesses   = (/1.,1.,1.,1.,1.,1.,1.,1.,1.,5./)       ; Define line thicknesses 
   res@xyDashPatterns      = (/0.,0.,0.,0.,0.,0.,0.,0.,0.,0./)           ; Dash patterns 
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
   res@pmLegendParallelPosF   = 0.92                 ; move units right
   res@pmLegendOrthogonalPosF = -0.60                ; move units down
   res@pmLegendWidthF         = 0.08                ; Change width and
   res@pmLegendHeightF        = 0.145                ; height of legend.
   res@lgLabelFontHeightF     = 0.008                 ; change font height
   res@lgTitleOn              = True               ; turn on legend title
   res@lgTitleString          = "~F22~Data set"           ; create legend title
   res@lgTitleFontHeightF     = .010                ; font of legend title
   res@lgPerimOn              = False               ; turn off box around
   ;res@xyExplicitLegendLabels = (/"UDEL","PRECL","GPCP","GPCC","CRU","CPC","CMAP","CHIRPS","ARC2"/)         ; explicit labels   
   res@xyExplicitLegendLabels = (/"ARC2","CHIRPS","CMAP","CPC","CRU","GPCC","GPCP","PRECL","UDEL","Ensemble"/)         ; explicit labels

;==================================================================================
 
  plot(0)  =  gsn_csm_xy(wks,xlabel,m_index(lev|0:,month|:),res)

  res@trYMaxF             =   60.         
  res@tiYAxisString = "Standard deviation (mm month~S~-1~N~)"                  ; yaxis  
  plot(1)  =  gsn_csm_xy(wks,xlabel,d_index(lev|0:,month|:),res)
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
tt_p0 = new(18,graphic)                ; create graphic array ; only needed if paneling
;---Attach the polyline
     do i = 0,1,1
      tt_p0(i) = gsn_add_annotation(plot(i),create_tt(i),amres5)
     end do 
 delete(i)
;
;

;===============================================================
;======================================================================== 
;========================================================================
  latEQ = (/ 200.,  200.,  0.,   0., 200./)
  lonEQ = (/5.95, 8.05, 8.05, 5.95,5.95/)
;---Resources for the polyline
  pres0                  = True           ; polyline mods desired
 ; pres0@gsLineThicknessF = 2.            ; line thickness   
  pres0@gsFillColor      = "grey"         ; color of lines
  pres0@gsFillOpacityF 	 = 0.2
  pres0@tfPolyDrawOrder   = "postDraw"
 
 dum0 = gsn_add_polygon(wks,plot(0),lonEQ,latEQ,pres0)
 dum1 = gsn_add_polygon(wks,plot(1),lonEQ,latEQ,pres0)

  
;---------------------------------------------------------------
;===============================================================

 
  resP                                  = True         ; modify the panel plot
  resP@gsnDraw                          = True      ; don't draw yet
  resP@gsnFrame                         = False        ; don't advance frame yet
  resP@gsnPanelLabelBar    	        = False       ; add common colorbar
  resP@gsnPanelYWhiteSpacePercent      	= 0.0    ; default is 1.0
  resP@gsnPanelXWhiteSpacePercent      	= 0.0    ; default is 1.0
  resP@gsnPanelTop                      = 1.0
  ;resP@gsnPanelBottom                   = 0.51
  resP@gsnPanelLeft                     = 0.01
  resP@gsnPanelRight                    = 0.99
 ; resP@lbTitleFontHeightF	        = 0.010 
;  resP@lbLabelFontHeightF               = 0.010
 ; resP@lbLabelStride		        = 5
;  resP@lbLabelFont   		        = "Helvetica-Bold"     ; label font
 ; resP@lbTitleString                  	= "EOF1 Precipitation Pattern (mm month~S~-1~N~)"
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
   
  gsn_panel(wks,plot(0:),(/2,1/),resP)     ; now draw as one plot
 
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
   res_P@lbTitleString                  = "EOF2 Precipitation Pattern (mm month~S~-1~N~)"
  ;res_P@lbTitleString                  	= "SST trend (~S~o~N~C per 35-yr)"
   res_P@lbTopMarginF                     = 0.5
   res_P@gsnMaximize                      = True         ; large format
   res_P@gsnPaperOrientation              = "portrait"   ; force portrait
   res_P@gsnLeftString 			= ""
  ;res_P@txString          		= "SST trends: 1984-2008"
  ; res_P@txString          		= "JAS SST trends: 1984-2009"

  ; gsn_panel(wks,plot(9:17),(/3,3/),res_P)               ; create panel plots
;==============================================================      ;;===============================================================
;===============================================================
;===============================================================
end

