begin

  yrStrt = 1891
  yrLast = 2019
  xlabel = ispan(yrStrt,yrLast,1)
  print(xlabel)

 ; neof   =  2        ; number of EOFs


; ==============================================================
; Open the file: Read only the user specified period
; ==============================================================
  f      = addfile("/home/hnnamchi/work/datasets/rain/annual_total_stn_gpcc_025_global.nc", "r")
 ;f      = addfile("/home/hnnamchi/work/datasets/rain/annual_total_stn_gpcc_025.nc", "r")

  TIME   = f->time
  YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
  iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

  gpcc    = f->numgauge(iYYYY,0,0)
  printVarSummary(gpcc)
  print(gpcc)  ; variable overview
;
;
; Extract the YYYYMM from the time coordinate 
  ;yyyymm = cd_calendar(stn&time,-2)/100 
;year = yyyymm/100
;print(xxxxxxx)
;---------------------------------
;
; PLOTS
;
;
  wks = gsn_open_wks("eps","fn0_1")         ; send graphics to PNG file
  plot = new(6,graphic)                ; create graphic array
                                          ; only needed if paneling
  plotS = new(6,graphic)                ; create graphic array
  
  rts           = True
  rts@gsnDraw   = False       ; don't draw yet
  rts@gsnFrame  = False       ; don't advance frame yet
  rts@gsnScale  = True        ; force text scaling               
  rts@vpHeightF = 0.50        ; Changes the aspect ratio
  rts@vpWidthF  = 0.95
  rts@vpXF      = 0.10        ; change start locations
  rts@vpYF      = 0.75        ; the plot
  rts@xyLineColor         =  "deepskyblue"
  rts@xyLineThicknesses   = (/1.5/)       ; Define line thicknesses 
  rts@trXMinF             =  yrStrt-5                 ; manually set lower limit
  rts@trXMaxF             =  yrLast+5                 ;   "          upper
  ;rts@trYMinF             =   0.0                 ; manually set lower limit
  ;rts@trYMaxF             =   9000.0                 ;   "          upper
  rts@tiYAxisString = ""                    ; y-axis label 
  rts@tiXAxisFontHeightF = 0.025
  rts@tiYAxisFontHeightF = 0.025  
  rts@gsnLeftStringFontHeightF = 0.030   
  rts@gsnYRefLine           = 0.              ; reference line   
  rts@gsnYRefLineThicknesses = (/0.1/)  
  rts@gsnYRefLineDashPatterns = (/2/)  
  rts@tmYLFormat	   = "@*+^sg"	; use "e" symbol, don't force 0's (see documentation)
; panel plot only resources
  rts@tmXBMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  rts@tmXBMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  rts@tmYLMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  rts@tmYLMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  rts@tmXTMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  rts@tmXTMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  rts@tmYRMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  rts@tmYRMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  rts@tiYAxisString   = "Number of stations"
;=============================================================================
  rts@tiXAxisString = "year"                  ; yaxis
  
   DATA_NAMES = (/"Trend + Variability","Trend + Variability"/)
 ; do n=0,neof-1
   ;     rts@gsnLeftString  = DATA_NAMES(n)
       ; rts@tiYAxisString   = "Normalized PC"+(n+1)
     ;rts@tiYAxisString   = "Normalized PC"+(n+1)
     ;rts@gsnRightString = sprintf("%5.1f", eof@pcvar(n)) +"%"
      plot(0) = gsn_csm_xy(wks,xlabel,gpcc,rts)
    
 ; overlay(plot(n),plotS(n))
 ; plot(n) = plot(n)

  ;end do
;delete(n)
;
;=====================================================================
;=====================================================================
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
var_names = (/"CRU","GPCC","UDEL"/)
printVarSummary(var_names)
print(var_names)

  txres               = True         ; Text resources
  txres@txFontHeightF = 0.022
  txres@txJust        = "CenterLeft"
  txres@txAngleF      =  0.
  txres@txFont                = "Helvetica"

  labels0  = var_names
  xpos0    = fspan(0.15, 0.70,dimsizes(var_names))
; xpos0    = fspan(0.05, 0.70,dimsizes(var_names))

; do i = 0,dimsizes(labels0)-1,1
;   gsn_text_ndc(wks,labels0(i),xpos0(i),0.96,txres)
;  end do
;delete(i)
delete(txres)
delete(var_names)
delete(labels0)
delete(xpos0)
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;---------------------------------------------------------------------
var_names = (/"Sahel mode, PC1","Guinea Coast mode, PC2"/)
printVarSummary(var_names)
print(var_names)

  txres               = True         ; Text resources
  txres@txFontHeightF = 0.012
  txres@txJust        = "CenterLeft"
  txres@txFont                = "Helvetica-Bold"
  txres@txAngleF      =  0.

  labels0  = var_names
  xpos0    = fspan(0.150, 0.60,dimsizes(var_names))

 ;do i = 0,dimsizes(labels0)-1,1
;     gsn_text_ndc(wks,labels0(i),xpos0(i),0.98,txres)
;  end do
;delete(i)
;delete(txres)
;=====================================================================
;=====================================================================

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

  amres5@amParallelPosF   =  -0.45 ; 0.5 is the right edge of the plot, so
  amres5@amOrthogonalPosF =  -0.42    ; This is the center of the plot.
  amres5@amJust           = "TopLeft"

 tt = (/"(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)","(j)","(k)","(l)","(m)","n","o"/)
 create_tt = gsn_create_text(wks,tt,txres5);
tt_p0 = new(12,graphic)                ; create graphic array ; only needed if paneling
;---Attach the polyline
     do i = 0,5,1
 ;     tt_p0(i) = gsn_add_annotation(plot(i),create_tt(i),amres5)
     end do 
; delete(i)
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

  dum0 = new(12,graphic)  
  dum1 = new(12,graphic)    
  ;---Attach the polyline
     do i = 0,neof-1,1
 ;     dum0(i) = gsn_add_polyline(wks,plot(i),lonEQ,latEQ,pres0)
     end do 
;delete(i)
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
  resP                                  = True         ; modify the panel plot
  resP@gsnDraw                          = True      ; don't draw yet
  resP@gsnFrame                         = False        ; don't advance frame yet
  resP@gsnPanelLabelBar    	        = False        ; add common colorbar
  resP@gsnPanelYWhiteSpacePercent      	= 1.0    ; default is 1.0
  resP@gsnPanelXWhiteSpacePercent      	= 1.0    ; default is 1.0
  resP@gsnPanelTop                      = 0.99
  resP@gsnPanelBottom                   = 0.01
  resP@gsnPanelLeft                     = 0.01
  resP@gsnPanelRight                    = 0.99
  resP@gsnMaximize                      = True         ; large format
  resP@gsnPaperOrientation              = "portrait"   ; force portrait
  resP@gsnLeftString 			= ""
  ;resP@txString          		= "SST trends: 1984-2008"
  ;resP@txString          		= "EOF1 of June-July-August rainfall"
  resP@txFontHeightF			=  0.025
 
;*******************************************
 ; resP@gsnPanelCenter   = False                 ; =True .... must move labels
 ; resP@gsnPanelRowSpec  = True                  ; tell panel what order to plot
 ; gsn_panel(wks,plot,(/1,2,2/),resP)
;*******************************************
gsn_panel(wks,plot(0:0),(/1,1/),resP)     ; now draw as one plot

;===============================================================
;===============================================================
;===============================================================
  res_P                                  = True         ; modify the panel plot
  res_P@gsnDraw                          = True      ; don't draw yet
  res_P@gsnFrame                         = False        ; don't advance frame yet
  res_P@gsnPanelLabelBar    	        = True        ; add common colorbar
  res_P@gsnPanelYWhiteSpacePercent      	= 1.0    ; default is 1.0
  res_P@gsnPanelXWhiteSpacePercent      	= 1.0    ; default is 1.0
  res_P@gsnPanelTop                      = 0.40
  res_P@gsnPanelBottom                   = 0.05
  res_P@gsnPanelLeft                     = 0.01
  res_P@gsnPanelRight                    = 0.99
  res_P@lbTitleFontHeightF	        = 0.010 
  res_P@lbLabelFontHeightF               = 0.010
  res_P@lbLabelStride		        = 5
  res_P@lbLabelFont   		        = "Helvetica-Bold"     ; label font
  res_P@lbTitleString                  	= "Rainfall (mm month~S~-1~N~)"
  ;res_P@lbTitleString                  	= "SST trend (~S~o~N~C per 35-yr)"
  res_P@lbOrientation                    = "vertical"
  res_P@lbTitleFontHeightF	        = .010
  res_P@lbLabelFontHeightF               = 0.010
  res_P@lbLabelFont   		        = "Helvetica-Bold"     ; label font
  res_P@lbTitleAngleF                    = 90.
  res_P@lbTitleDirection                 = "Across"
 ; res_P@lbTitleString                  		= " (s.d.~S~2~N~)SST deviations (~S~o~N~C)"
  res_P@lbTitlePosition                  = "Right"
  res_P@lbLeftMarginF                    = 0.2
  res_P@lbRightMarginF                   = 0.2
  res_P@lbTopMarginF			=  0.0
  res_P@lbBottomMarginF			=  0.0
  res_P@gsnMaximize                      = True         ; large format
  res_P@gsnPaperOrientation              = "portrait"   ; force portrait
  res_P@gsnLeftString 			= ""
  ;res_P@txString          		= "SST trends: 1984-2008"
  ;res_P@txString          		= "Ensemble mean and standard deviation"
 ; res_P@txFontHeightF			=  0.025
 
;*******************************************
 ; resP@gsnPanelCenter   = False                 ; =True .... must move labels
 ; resP@gsnPanelRowSpec  = True                  ; tell panel what order to plot
 ; gsn_panel(wks,plot,(/1,2,2/),resP)
;*******************************************
;gsn_panel(wks,plot(3:3),(/1,1/),res_P)     ; now draw as one plot
 
;===============================================================
;===============================================================
;===============================================================
end

