;*************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl"
 begin

  
  yrStrt = 1983
  yrLast = 1995
 
 ; nyear = (yrLast - yrStrt + 1)
  
  nmos = 12
  
  mxlag    = 20   ;Time lag
 
  xlabel = ispan(yrStrt,yrLast,1)
  print(xlabel)


  nn = 6	;start year	;5 is 1988
  mm = 12	;end year
  
 ; r = (/0.92,0.90,0.87,0.86,0.86,0.83,0.89,0.90,0.87,0.86,0.86,0.84,0.88/)	;rotated EOFs
 ; d = (/2.31,2.13,2.06,1.95,1.95,1.89,2.14,2.23,2.04,1.98,1.89,1.79,2.10/)	;scaled according to years-length
 ; rr = (/0.44,0.38,0.35,0.32,0.31,0.30,0.38,0.41,0.35,0.33,0.30,0.27,0.37/)


  r = (/0.93,0.94,0.93,0.89,0.90,0.82,0.90,0.90,0.87,0.87,0.87,0.84,0.88/)	;
  d = (/2.43,2.46,2.48,2.20,2.22,1.86,2.23,2.27,2.09,2.02,1.97,1.84,2.19/)	;scaled according to years-length
  rr= (/0.49,0.50,0.51,0.40,0.41,0.29,0.41,0.43,0.36,0.34,0.32,0.28,0.40/)


  m_r = avg(r(nn:))
  d_r = stddev(r(nn:mm))
;
  m_d = avg(d(nn:mm))
  d_d = stddev(d(nn:mm))
;
  m_rr= avg(rr(nn:mm))
  d_rr = stddev(rr(nn:mm))
;
print(m_r)
print(d_r*2)
print(m_d) 
print(d_d*2)
print(m_rr)
print(d_rr*2)  
;
;
;
m_r_all = (/avg(r(0:5)),avg(r(6:11)),avg(r(0:))/)
print(m_r_all)
d_r_all = (/stddev(r(0:5)),stddev(r(6:11)),stddev(r(0:))/)
d_r_all = 2*d_r_all
print(d_r_all)
;
m_d_all = (/avg(d(0:5)),avg(d(6:11)),avg(d(0:))/)
print(m_d_all)
d_d_all = (/stddev(d(0:5)),stddev(d(6:11)),stddev(d(0:))/)
d_d_all = 2*d_d_all
print(d_d_all)
;
m_rr_all = (/avg(rr(0:5)),avg(rr(6:11)),avg(rr(0:))/)
print(m_rr_all)
d_rr_all = (/stddev(rr(0:5)),stddev(rr(6:11)),stddev(rr(0:))/)
d_rr_all = 2*d_rr_all
print(d_rr_all)
;
;r_text = "Pattern Correlation: 0.82-0.90, 0.92(1983)"
;d_text = "Trend: 1.50-2.50, 2.31(1983)"
;rr_text = ":R~S~2~N~ 1.50-2.50, 2.31(1983)"

all_x = (/2.,4.,6./)
print(all_x)

;=========================================================================================
;=========================================================================================
print("===========================================================")
 wks = gsn_open_wks("eps","fn0_7")
 plot = new(4,graphic)                ; create graphic array
                                          ; only needed if paneling
   r2               = True                        ; plot mods desired
   r2@gsnDraw       = False                       ; do not draw
   r2@gsnFrame      = False                       ; do not advance frame
   r2@tiMainString  = ""                       ; title
   r2@tiXAxisFontHeightF = 0.015
   r2@tiXAxisString = "starting year"  ; xaxis
   r2@tiYAxisFontHeightF = 0.015
   r2@tiYAxisString = "Pattern correlation"                  ; yaxis
   ;r2@tiYAxisString = "SST (~S~o~N~C)"                  ; yaxis
   ;r2@tiYAxisAngleF  =  270.
   r2@tmXBLabelFontHeightF = 0.012
   r2@tmYLLabelFontHeightF = 0.012
   r2@trYLog              = False                ; log scaling
   r2@trXLog              = False               ; log scaling
   ;r2@trXMinF             = 1940.                 ; manually set lower limit
   ;r2@trXMaxF             = 2020.                ;   "          upper
    
   r2@trXMinF             =  min(xlabel)-1                 ; manually set lower limit
   r2@trXMaxF             =  max(xlabel)+1                ;   "          upper
  
   r2@gsnXRefLineThicknesses = (/0.5/)
   r2@gsnXRefLineDashPatterns = (/2./)
   r2@xyLineColors        = (/"blue","red","transparent"/)
   r2@tmXTBorderOn            =  True
   r2@tmXTOn                  =  True
      
   r2@tmYLFormat = "@*+^sg"	; use "e" symbol, don't force 0's (see documentation)
   ;r2@gsnXRefLine            =  (/1988./) 
   
   r2@vpWidthF                = 0.60
   r2@vpHeightF               = 0.40
  ; r2@tmXBMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  ; r2@tmXBMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  ; r2@tmYLMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  ; r2@tmYLMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
  ; r2@tmXTMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  ; r2@tmXTMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
 ;  r2@tmYRMajorOutwardLengthF = 0.0               ; draw tickmarks inward
 ;  r2@tmYRMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
 
   r2@xyLineThicknesses   = (/1.,1.,1./)       ; Define line thicknesses 
   r2@xyDashPatterns      = (/0.,2.,2./)           ; Dash patterns 
   r2@tmYLLabelFontColor = "blue"   ; and right axes are same.
   r2@tiYAxisFontColor  = "blue"
   ;r2@tmBorderLineColor = "deepskyblue"
   ;r2@tmYLMajorLineColor = "red" ; YR axis uses YL resources, can
   ;r2@tmYLMinorLineColor = "red" ; change by setting tmYUseLeft = False 
   ;r2@tmBorderLineColor =  "red"
 
    r2@tmXBMode = "Explicit"
    r2@tmXBValues = (/"1983", "1984","1985","1986","1987","1988","1989","1990","1991","1992","1993","1994","1995"/)
    r2@tmXBLabels = r2@tmXBValues 
    r2@tmXBLabelAngleF	=	22.5
   ;r2@tmXBLabels = (/"1", "2","3","4","5","6","7","8","10","10","11","12","13"/)
   
   
;===============================================================
;=============================================================== 
;***********************************************
  
    
   
     
   r1               = True                        ; plot mods desired
   r1@gsnDraw       = False                       ; do not draw
   r1@gsnFrame      = False                       ; do not advance frame
   r1@tiXAxisString = ""  ; xaxis
   r1@tiYAxisString = "Trend (~F33~s~S~2~N~~F21~/number of years)"      
   r1@tiYAxisAngleF  =  270. 
   r1@xyLineColors   =  (/"deepskyblue","deepskyblue","transparent"/)
   r1@xyLineThicknesses  =  (/1.,1.,1./)
   r1@xyDashPatterns     =  (/16.,0.,0./)
   r1@tiXAxisFontHeightF = 0.015
   r1@tiYAxisFontHeightF = 0.015
   r1@tmXBLabelFontHeightF = 0.012
   r1@tmYLLabelFontHeightF = 0.012
       
   r1@tmYUseLeft          =  True
   r1@trYMinF             =  0.0                 ; manually set lower limit
   r1@trYMaxF             =  5.0                 ;   "          upper
   
   r1@trXMinF             =  min(xlabel)-1                 ; manually set lower limit
   r1@trXMaxF             =  max(xlabel)+1                ;   "          upper
   
     
   r1@vpWidthF                = 0.60
   r1@vpHeightF               = 0.40
   r1@tmXTBorderOn            =  True
   r1@tmXTOn                  =  False
   ;r1@tmXTMode = "Explicit"
   ;r1@tmXTValues = (/"0", "1","2","3","4","5","6","7","8","9","10","11","12"/)
   ;r1@tmXTLabels = (/"1", "2","3","4","5","6","7","8","10","10","11","12"/)
   
  r1@tmYRLabelFontColor = "deepskyblue"   ; and right axes are same.
  r1@tiYAxisFontColor  = "deepskyblue"
  ;r1@tiYAxisString   = "SSH anomaly (cm)"
  
  r1@tmXTLabelsOn        = False    ; have tick mark labels
  r1@tmXTOn              = True      ; have tick marks
  r1@tmYRLabelFontColor = "deepskyblue"   ; and right axes are same.
  r1@tiYAxisFontColor  = "deepskyblue"
 ; r1@tmBorderLineColor =  "deepskyblue"
  r1@tmYLBorderOn 	 = False
  r1@tmYRBorderOn	 = True
  r1@tmXTBorderOn	 = False
  r1@tmXBBorderOn	 = False
  ;r1@tmBorderLineColor = "deepskyblue"
  ;r1@tmYRMajorLineColor = "deepskyblue" ; YR axis uses YL r1ources, can
  ;r1@tmYRMinorLineColor = "deepskyblue" ; change by setting tmYUseLeft = False 
  ;r1@gsnYRefLine           = avg(RAPID)
  r1@gsnYRefLineColor     = "deepskyblue"
  r1@tmYRFormat   	=  "@*+^sg"          ; trim the uneccecary "0" in labels. 
    
     
  ; r1@tmXBMajorOutwardLengthF = 0.0               ; draw tickmarks inward
  ; r1@tmXBMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
 ;  r1@tmYLMajorOutwardLengthF = 0.0               ; draw tickmarks inward
 ;  r1@tmYLMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
   ;r1@tmXTMajorOutwardLengthF = 0.0               ; draw tickmarks inward
 ;  ;r1@tmXTMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
 ;  r1@tmYRMajorOutwardLengthF = 0.0               ; draw tickmarks inward
 ;  r1@tmYRMinorOutwardLengthF = 0.0               ; draw minor ticsk inward
;========================================================
  r3             = True
  r3@trYMinF             =  0.0                 ;   "          upper
  r3@trYMaxF             =  1.0                 ;   "          upper
  r3@xyDashPatterns     =  (/3.,0.,0./)
  r3@tmXBLabelFontHeightF = 0.012
  r3@tmYLLabelFontHeightF = 0.012
  r3@tmYLLabelFontColor = "red"   ; and right axes are same.
  r3@tiYAxisFontColor  = "red"
  r3@xyLineColors        = (/"red","red","transparent"/)
  r3@tmYRLabelFontColor = "red"   ; and right axes are same.
  r3@tiYAxisFontColor  = "red"
  r3@tiYAxisString = "R~S~2~N~"                  ; yaxis
  r3@tmYRFormat = "@*+^sg"
  r3@trYMinF             =  0.20                 ; manually set lower limit
  r3@trYMaxF             =  0.60                 ;   "          upper
;======================================================== 
  
  r2@tiMainString  = ""                       ; title
  r2@tiMainOffsetYF	     =  -0.04		 ;Put title in the panels
;  plot(0)  =  gsn_csm_x2y2(wks,xlabel,xlabel,m_OISST,m_GPCP,r2,r1)


  r1@trYMinF             =  1.4                 ; manually set lower limit
  r1@trYMaxF             =  2.6                 ;   "          upper

  r2@trYMinF             =  0.80                 ; manually set lower limit
  r2@trYMaxF             =  0.96                 ;   "          upper

  r2@tiMainString  = ""                       ; title
  r2@tiMainOffsetYF	     =  -0.01		 ;Put title in the panels
  ;plot(1)  =  gsn_csm_x2y2(wks,xlabel,xlabel,d_OISST,d_GPCP,r2,r1)
  plot(0)  =  gsn_csm_xy3(wks,xlabel,r,d,rr,r2,r1,r3)
;

  
  ;========================================================
  r0             = True
  r0@gsnDraw       = False                       ; do not draw
  r0@gsnFrame      = False                       ; do not advance frame
  r0@trYMinF             =  0.0                 ;   "          upper
  r0@trYMaxF             =  1.0                 ;   "          upper
  r0@xyDashPatterns     =  (/3.,0.,0./)
  r0@tmXBLabelFontHeightF = 0.030
  r0@tmYLLabelFontHeightF = 0.030
  r0@tiXAxisFontHeightF	  = 0.030
  r0@tiYAxisFontHeightF	  = 0.030
  ;r0@tmYLLabelFontColor = "red"   ; and right axes are same.
  ;r0@tiYAxisFontColor  = "red"
  r0@xyLineColors        = (/"blue","red","transparent"/)
  r0@tmYRLabelFontColor = "blue"   ; and right axes are same.
  r0@tiYAxisFontColor  = "blue"
  r0@tmYLFormat = "0@*+^sg"
  r0@tiYAxisString = "Pattern correlation"                  ; yaxis
  r0@trYMinF             =  0.80                 ; manually set lower limit
  r0@trYMaxF             =  1.00                 ;   "          upper
  r0@trXMinF             =  min(all_x)-1                 ; manually set lower limit
  r0@trXMaxF             =  max(all_x)+1                ;   "          upper
  r0@tiXAxisString = "starting year"  ; xaxis
  r0@tmXBMode = "Explicit"
  r0@tmXBValues = all_x
  r0@tmXBLabels = (/"1983-88","1989-94","1983-95"/)
;======================================================== 
  plot(1)  =  gsn_csm_xy(wks,all_x,rr(0:2),r0)

  r0@trYMinF             =  1.4                 ; manually set lower limit
  r0@trYMaxF             =  2.8                 ;   "          upper
  r0@xyLineColors        = (/"deepskyblue","red","transparent"/)
  r0@tmYRLabelFontColor = "deepskyblue"   ; and right axes are same.
  r0@tiYAxisFontColor  = "deepskyblue"
  r0@tiYAxisString = "Trend (~F33~s~S~2~N~~F21~/number of years)"   
  r0@tmYLFormat = "@*+^sg"   
  plot(2)  =  gsn_csm_xy(wks,all_x,r(0:2),r0)

  r0@trYMinF             =  0.20                 ; manually set lower limit
  r0@trYMaxF             =  0.70                 ;   "          upper
  r0@xyLineColors        = (/"red","red","transparent"/)
  r0@tmYRLabelFontColor = "red"   ; and right axes are same.
  r0@tiYAxisFontColor  = "red"
  r0@tiYAxisString = "R~S~2~N~"                  ; yaxis
  plot(3)  =  gsn_csm_xy(wks,all_x,r(0:2),r0)

 
;----------------------------------------------------------------------
;===============================================================
;===============================================================
;---Resources for the polyline
  pres0                  = True           ; polyline mods desired  
  pres0@gsFillColor      = "grey85"         ; color of lines
  pres0@tfPolyDrawOrder       = "PreDraw"    ; Draw any attached primitives
  pres0@gsFillIndex = 0
  pres0@gsFillOpacityF     = 0.40

;-------------------------
; xb0 =  (/-mxlag,mxlag,mxlag,-mxlag,-mxlag/)
; yb0 =  (/sig95,sig95,0.5,0.5,sig95/)
 
 ;dum0 = gsn_add_polygon(wks,plot(0),xb0,yb0,pres0)          ; 
 ;dum1 = gsn_add_polygon(wks,plot(1),xb0,yb0,pres0)   
;-------------------------

;=====================================================================
;************************************************
; add error bars
;************************************************  
  polyres                   = True                       ; marker resources
  polyres@gsMarkerIndex     = 16                          ; index for circle
  ;polyres@gsMarkerColor	    = "cyan"
  polyres@gsMarkerSizeF     = .008                        ; size
  polyres@gsLineThicknessF = 3.            ; line thickness   
  ;polyres@gsLineColor      = polyres@gsMarkerColor         ; color of lines
  polyres@gsLineDashPattern = 0
  polyres@gsMarkerOpacityF  = 1.0
  ;marker_colors = (/"black","pink3","red3","seagreen4","yellow3"/)
  marker_colors = (/"seagreen3","deeppink3","black","seagreen4","yellow3"/)
 
  
   bb = 0.15	;scaling factor for bars
   M_OBS  = m_r_all
   rM_OBS = d_r_all
 


  print(M_OBS)
  print(rM_OBS)
  x1 = all_x
 
  error_bar_n_0 = new(dimsizes(M_OBS),graphic)
  up_bar_n_0 = new(dimsizes(M_OBS),graphic)
  lo_bar_n_0 = new(dimsizes(M_OBS),graphic)
  centers_n_0   = new(dimsizes(M_OBS),graphic)
   
  
do t=0,dimsizes(M_OBS)-1,1
   polyres@gsMarkerColor =  marker_colors(t)
   polyres@gsLineColor =  marker_colors(t)
   centers_n_0(t)   = gsn_add_polymarker(wks,plot(1),x1(t),M_OBS(t),polyres)
   
   error_bar_n_0(t) = gsn_add_polyline(wks,plot(1),(/x1(t),x1(t)/),(/(M_OBS(t)+rM_OBS(t)),(M_OBS(t)-rM_OBS(t))/),polyres)
   up_bar_n_0(t) = gsn_add_polyline(wks,plot(1),(/x1(t)-bb,x1(t)+bb/),(/(M_OBS(t)+rM_OBS(t)),(M_OBS(t)+rM_OBS(t))/),polyres)
   lo_bar_n_0(t) = gsn_add_polyline(wks,plot(1),(/x1(t)-bb,x1(t)+bb/),(/(M_OBS(t)-rM_OBS(t)),(M_OBS(t)-rM_OBS(t))/),polyres)
end do

delete(t)

;----------------------------------

   M_OBS  = m_d_all
   rM_OBS = d_d_all

  error_bar_n_1 = new(dimsizes(M_OBS),graphic)
  up_bar_n_1 = new(dimsizes(M_OBS),graphic)
  lo_bar_n_1 = new(dimsizes(M_OBS),graphic)
  centers_n_1   = new(dimsizes(M_OBS),graphic)
  
 

do t=0,dimsizes(M_OBS)-1,1
   polyres@gsMarkerColor =  marker_colors(t)
   polyres@gsLineColor =  marker_colors(t)
   centers_n_1(t)   = gsn_add_polymarker(wks,plot(2),x1(t),M_OBS(t),polyres)
   
   error_bar_n_1(t) = gsn_add_polyline(wks,plot(2),(/x1(t),x1(t)/),(/(M_OBS(t)+rM_OBS(t)),(M_OBS(t)-rM_OBS(t))/),polyres)
   up_bar_n_1(t) = gsn_add_polyline(wks,plot(2),(/x1(t)-bb,x1(t)+bb/),(/(M_OBS(t)+rM_OBS(t)),(M_OBS(t)+rM_OBS(t))/),polyres)
   lo_bar_n_1(t) = gsn_add_polyline(wks,plot(2),(/x1(t)-bb,x1(t)+bb/),(/(M_OBS(t)-rM_OBS(t)),(M_OBS(t)-rM_OBS(t))/),polyres)
end do

delete(t)

;----------------------------------

   M_OBS  = m_rr_all
   rM_OBS = d_rr_all

  error_bar_n_2 = new(dimsizes(M_OBS),graphic)
  up_bar_n_2 = new(dimsizes(M_OBS),graphic)
  lo_bar_n_2 = new(dimsizes(M_OBS),graphic)
  centers_n_2   = new(dimsizes(M_OBS),graphic)
  
 

 
do t=0,dimsizes(M_OBS)-1,1
   polyres@gsMarkerColor =  marker_colors(t)
   polyres@gsLineColor =  marker_colors(t)
   centers_n_2(t)   = gsn_add_polymarker(wks,plot(3),x1(t),M_OBS(t),polyres)
   
   error_bar_n_2(t) = gsn_add_polyline(wks,plot(3),(/x1(t),x1(t)/),(/(M_OBS(t)+rM_OBS(t)),(M_OBS(t)-rM_OBS(t))/),polyres)
   up_bar_n_2(t) = gsn_add_polyline(wks,plot(3),(/x1(t)-bb,x1(t)+bb/),(/(M_OBS(t)+rM_OBS(t)),(M_OBS(t)+rM_OBS(t))/),polyres)
   lo_bar_n_2(t) = gsn_add_polyline(wks,plot(3),(/x1(t)-bb,x1(t)+bb/),(/(M_OBS(t)-rM_OBS(t)),(M_OBS(t)-rM_OBS(t))/),polyres)
end do

delete(t)

 polyres@gsMarkerColor =  marker_colors(0)
 polyres@gsMarkerIndex     = 7                          ; index for circle
 polyres@gsMarkerSizeF     = .015                        ; size
 centers_r83   = gsn_add_polymarker(wks,plot(1),x1(0),r(0),polyres)
 centers_d83   = gsn_add_polymarker(wks,plot(2),x1(0),d(0),polyres)
 centers_rr83   = gsn_add_polymarker(wks,plot(3),x1(0),rr(0),polyres)
 
   
xa0 = (/1983.,1988.,1988.,1983.,1983./)
xa1 = (/1989.,1994.,1994.,1993.,1989./)
xb = (/0.,0.,120000.,120000.,0./)

pr0  = True
pr0@gsFillColor =  "seagreen3"
pr0@tfPolyDrawOrder = "PreDraw"
pr0@gsFillIndex  =  0
pr0@gsFillOpacityF = 0.1

d0 =   gsn_add_polygon(wks,plot(0),xa0,xb,pr0)
pr0@gsFillColor =  "deeppink3"
d1 =   gsn_add_polygon(wks,plot(0),xa1,xb,pr0)


;=========================================================================
;=========================================================================
  txres5               = True
  txres5@txAngleF      = 0.          ; Rotate string clockwise 
  txres5@txFontHeightF = 0.015   ; Use same font height as left axis
  txres5@txFont                = "Helvetica-Bold"
 ; txid = gsn_create_text(wks, "DT anomaly (~S~o~N~C)", txres)
   txid5 = gsn_create_text(wks, "(a)", txres5);
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
 
 annoid5d = gsn_add_annotation(plot(0),txid5,amres5)  ; 




 txres5@txFontHeightF = 0.040   ; Use same font height as left axis

 tt = (/"(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)","(j)","(k)","(l)","(m)","(n)","(o)","(p)","(q)","(r)","(s)","(t)","(u)","(v)","(w)"/)
 create_tt = gsn_create_text(wks,tt,txres5);
tt_p0 = new(8,graphic)                ; create graphic array ; only needed if paneling
tt_p1 = new(8,graphic)
;---Attach the polyline
     do i = 1,3,1
      tt_p0(i) = gsn_add_annotation(plot(i),create_tt(i),amres5)
     ; tt_p1(i) = gsn_add_annotation(plot(i+2),create_tt(i+2),amres5)
     end do 
 delete(i)
;
;
;===============================================================
;==============================================================
;===============================================================
;===============================================================
; panel plot only resources
  resP                   	  	= True        ; modify the panel plot
  resP@gsnDraw            		 = True       ; don't draw yet
  resP@gsnFrame            		 = False        ; don't advance frame yet
  resP@gsnPanelYWhiteSpacePercent 	= 0.0    ; default is 1.0
  resP@gsnPanelXWhiteSpacePercent 	= 0.0    ; default is 1.0
  resP@gsnMaximize         		= True         ; large format
  resP@lbTitleFontHeightF		= .010 
  resP@lbLabelFontHeightF               = 0.010
  resP@lbLabelFont   			= "Helvetica-Bold"     ; label font
  resP@lbTitleString    		= "SST anomaly (K)"
  resP@gsnPaperOrientation 		= "portrait"
  resP@gsnPanelFigureStringsBackgroundFillColor = "transparent"
  resP@gsnPanelFigureStrings = (/"","","","d","e","f"/) ; add strings to panel
  resP@amJust   			= "TopLeft"
  resP@gsnPanelTop                      = 0.99
  resP@gsnPanelBottom                   = 0.50
  resP@gsnPanelLeft                     = 0.01
  resP@gsnPanelRight                    = 0.99
  resP@gsnPanelFigureStringsFontHeightF = 0.015
  resP@gsnPanelFigureStringsPerimOn 	= False
  resP@gsnMaximize         		= True         ; large format
  gsn_panel(wks,plot,(/1,1/),resP)
 ; gsn_panel(wks,plot,(/1,2/),resP)
;--------------------------
;===============================================================
;***********************************************
; panel plot only resources
  res_P                     		 = True            ; modify the panel plot
  res_P@gsnDraw            		 = True       ; don't draw yet
  res_P@gsnFrame            		 = False        ; don't advance frame yet
  res_P@gsnPanelTop                      = 0.65
  res_P@gsnPanelBottom                   = 0.05
  res_P@gsnPanelLeft                     = 0.06
  res_P@gsnPanelRight                    = 0.85
  res_P@gsnPaperOrientation = "portrait"   ; force portrait
  ;res_P@gsnPanelFigureStrings   = (/"~F0~Peak~F34~;~F0~74 yr~S~-1~N~","~F0~Peak~F34~;~F0~12 yr~S~-1~N~"/)
  ;res_P@gsnPanelFigureStringsFontHeightF = 0.015
  ;res_P@gsnPanelFigureStringsJust    =     "CenterRight"
  ;res_P@amJust               =   "CenterRight"
  res_P@gsnMaximize          = True            ; large format
  gsn_panel(wks,plot(1:),(/1,3/),res_P)     ; now draw as one plot
;======================================================
;======================================================
frame(wks)
end
