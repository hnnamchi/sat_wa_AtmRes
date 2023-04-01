;*************************************************
;*************************************************
;load "/home/hyacinth/work/geomar/adv/season.ncl"
begin
;==============================================================
; User defined parameters that specify region of globe and
;==============================================================

  season = "JAS"
  sea1 = 6
  sea2 = 9  
  
  p95  =  0.95
 
 
  opt = True

  nmos = 12

  nplts = 35
 
  latS   =  0.
  latN   =  20. 
  lonL   = -20.
  lonR   =  20.


  
  yrStrt = 1983
  yrLast = 2018
  
 
  
yyyymm = yyyymm_time(yrStrt, yrLast, "integer")
printVarSummary(yyyymm) 
 
dlen   =  35

;=====================================
;=====================================
;===============================================================================================================
;============================================================
;================================================================
; ===============================================================
; Open the file: Read only the user specified period
; ==============================================================
 f      = addfile("/home/hyacinth/work/datasets/rain/precip_arc2_chirps_cmap_cpc_cru_gpcc_gpcp_precl_udel_1983_2017.nc", "r")
;f      = addfile("/home/hyacinth/work/datasets/rain/annual_arc2_chirps_cmap_cpc_cru_gpcc_gpcp_precl_udel_1983_2017.nc", "r")
;f      = addfile("/home/hyacinth/work/datasets/rain/annual_precip_chirps_cmap_cpc_cru_gpcc_gpcp_precl_udel_1983_2017.nc", "r")
;f      = addfile("/home/hyacinth/work/datasets/rain/annual_precip_chirps_cmap_cpc_cru_gpcc_gpcp_persiann_precl_udel_1983_2017.nc", "r")
  TIME   = f->time
  YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
  iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

  rain    = f->precip(:,:,{latS:latN},{lonL:lonR})
   a    = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
   lsdata = a->LSMASK
   lsm  = landsea_mask(lsdata,rain&lat,rain&lon)
   rain = mask(rain,lsm.eq.0,False)
   

  printVarSummary(rain)       ; variable overview
  printMinMax(rain,True) 
;=========================================================================================
;------------------------------------------------------------------
; ==============================================================
; compute desired global seasonal mean: month_to_season (contributed.ncl) 
; ==============================================================
  RAIN    = month_to_season (rain,season)
  printVarSummary(RAIN)

;  RAIN = dtrend_msg_n(RAIN&time,RAIN,True,False,0)
; =================================================================
;===================================

a_rain = dim_avg_n_Wrap(RAIN,0)
printVarSummary(a_rain)       ; variable overview
;
;
d_rain = dim_stddev_n_Wrap(RAIN,0)
printVarSummary(d_rain)       ; variable overview
;print(xxxxxxxx)
;===============================================================================================================
;===============================================================================================================
;===============================================================================================================
delete([/rain,YYYY,iYYYY,f,TIME/])
delete(lsm)
delete(lsdata)
;================================================================           
;============================================================
; PLOTS
;============================================================
  wks = gsn_open_wks("eps","fn0_3")         ; send graphics to PNG file

 ; plot = new(6,graphic)                ; create graphic array ; only needed if paneling
 
  plot2 = new(9,graphic)                ; create graphic array ; only needed if paneling
  plotS = new(9,graphic)                ; create graphic array ; only needed if paneling
  
  
; EOF patterns

  res                      = True         
  res@gsnDraw              = False        ; don't draw yet
  res@gsnFrame             = False        ; don't advance frame yet
  ;res@cnLevelSelectionMode = "ManualLevels"  ; set manual contour levels
  ;res@cnMinLevelValF       =  0.            ; set min contour level
  ;res@cnMaxLevelValF       =  2000.             ; set max contour level
  ;res@cnLevelSpacingF      =  50.            ; set contour spacing     
  res@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
  res@cnLevels    = (/ 5.,10.,20.,30.,40.,50.,100.,150.,200.,250.,300./)   ; set levels
 
  res@mpFillOn             = False        ; turn off map fill
  res@mpMinLatF            = latS         ; zoom in on map
  res@mpMaxLatF            = latN
  res@mpMinLonF            = lonL
  res@mpMaxLonF            = lonR
  res@pmTickMarkDisplayMode = "Never"
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
  res@cnFillPalette        = "precip4_11lev"  
  ;res@cnFillPalette        = "BlueWhiteOrangeRed"  
  res@cnLinesOn            = False        ; True is default
  res@cnLineLabelsOn       = False        ; True is default
  res@cnMissingValFillColor = "grey" ; comment this line out 
  
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
   
   


;======================================================
;==============================================================
;=========================================================;===============
;===============
;-----------------------------------------------------------------------------
  res0                      =   True
  res0@gsnDraw              = False        ; don't draw yet
  res0@gsnFrame             = False        ; don't advance frame yet
  res0@cnLevelSelectionMode = "ManualLevels"  ; set manual contour levels
  res0@cnMinLevelValF       =  -5.0            ; set min contour level
  res0@cnMaxLevelValF       =  5.0             ; set max contour level
  res0@cnLevelSpacingF      =  0.5            ; set contour spacing  
  res0@gsnAddCyclic         = False   
  res0@cnLinesOn            = True       ; True is default
  res0@cnLineLabelsOn       = False       ; True is default
  res0@cnInfoLabelOn        = False
  res0@gsnRightString   = ""
  res0@gsnLeftString   = ""
 ; res0@cnFillScaleF        = 2.         ; add extra density
  res0@cnLineLabelDensityF =  5.
 ; res0@cnFillDotSizeF       = 0.0001            ; increase dot size of contours
  res0@gsnContourZeroLineThicknessF = 0.
  res0@cnLabelMasking               =  True
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
  res1@cnMinLevelValF       =  0.90            ; set min contour level
  res1@cnMaxLevelValF       =  1.0             ; set max contour level
  res1@cnLevelSpacingF      =  .2            ; set contour spacing  
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
 ; opt@gsnShadeLow = 17                     ; use fill pattern #4
  opt@gsnShadeHigh = 17                  ; use pattern #2   
  ;opt@gsnShadeMid = 2   
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
 res@gsnLeftStringFontHeightF   = 0.030
 res@gsnCenterString  = ""
 res@gsnRightString  = ""  
 res@gsnLeftString  = ""  
 res1@gsnRightString  = ""  
 res@tmYLLabelsOn          = True      ;no lon ticks
 res@tmXBLabelsOn          = True      ;no lon ticks
 
   
  DATA_NAMES = (/"ARC2","CHIRPS","CMAP","CPC","CRU","GPCC","GPCP","PRECL","UDEL"/)
  res@gsnAddCyclic         = False
  ;res1@gsnAddCyclic         = True
  res@gsnLeftStringOrthogonalPosF = -0.95
  res@gsnLeftStringParallelPosF =  0.05
  res@gsnLeftStringFontColor = "white"
  
do n=0,8,1
     res@gsnLeftString  = DATA_NAMES(n)


  ;  if(n.eq.4)
  ;    res@trXTensionF = 10.
  ;  else
  ;   res@trXTensionF = 2.
  ; end if

   
   plot2(n) = gsn_csm_contour_map_ce(wks,a_rain(n,:,:),res)		;Means
   plotS(n) = gsn_csm_contour_map_ce(wks,d_rain(n,:,:),res)		;Standard deviations
   ;plotS(n) = gsn_csm_contour(wks,dSSTd(n,:,:),res1)
  ; plotS(n) = gsn_contour_shade(plotS(n),dSSTd@_FillValue,0.90,opt)
    
  ;overlay(plot2(n),plotS(n))
 ; plot2(n) = plot2(n)

end do

delete(n)
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
;=========================================================================
;=========================================================================
;=========================================================================
  txres5               = True
  txres5@txAngleF      = 0.          ; Rotate string clockwise 
  txres5@txFontHeightF = 0.040   ; Use same font height as left axis
  txres5@txFont                = "Helvetica-Bold"
 ; txid = gsn_create_text(wks, "DT anomaly (~S~o~N~C)", txres)
   txid5 = gsn_create_text(wks, "a", txres5);
; Move text string to center/right edge of plot.;
  amres5                  = True
  amres5@amParallelPosF   =  -0.50 ; 0.5 is the right edge of the plot, so
  amres5@amOrthogonalPosF =  -0.55    ; This is the center of the plot.
  amres5@amJust           = "TopLeft"
 amres5@amParallelPosF   =  -0.47 ; 0.5 is the right edge of the plot, so
 amres5@amOrthogonalPosF =  -0.45    ; This is the center of the plot.
 tt = (/"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o"/)
 tt2 = (/"j","k","l","m","n","o","p","q","r"/)
create_tt = gsn_create_text(wks,tt,txres5);
create_tt2 = gsn_create_text(wks,tt2,txres5);
tt_p0 = new(9,graphic)                ; create graphic array ; only needed if paneling
tt_p2 = new(9,graphic)                ; create graphic array ; only needed if paneling
;---Attach the polyline
     do i = 0,8,1
      tt_p0(i) = gsn_add_annotation(plot2(i),create_tt(i),amres5)
     end do 
 delete(i)

     do i = 0,8,1
      tt_p2(i) = gsn_add_annotation(plotS(i),create_tt2(i),amres5)
     end do 
 delete(i)

;===============================================================
;==============================================================
  latEQ = (/ 10.,  10.,  10.,   10., 10./)
  lonEQ = (/-20., 20., 20., -20.,-20./)

;---Resources for the polyline
  pres0                  = True           ; polyline mods desired
  pres0@gsLineThicknessF = 1.            ; line thickness   
  pres0@gsLineColor      = "black"         ; color of lines
  pres0@gsLineDashPattern = 16
  pres0@tfPolyDrawOrder   = "postDraw"

  dum0 = new(9,graphic)  
  dum1 = new(9,graphic)    
  ;---Attach the polyline
     do i = 0,8,1
;      dum0(i) = gsn_add_polyline(wks,plot2(i),lonEQ,latEQ,pres0)
     end do 
;delete(i)
  do i = 0,8,1
;      dum1(i) = gsn_add_polyline(wks,plotS(i),lonEQ,latEQ,pres0)
    end do 
;delete(i)


;-----------------------------------------------------------------------------
;=====================================================================
;=====================================================================
;======================================================== 
;========================================================
txr =  True
txr@txAngleF       =  0.
txr@txFontHeightF  =  0.020
txr@txFontColor  = "red"
txr@txFont    =  "Helvetica-Bold"

amres        =   True
amres@amParallelPosF  =    -0.20    ;left/right pos
amres@amOrthogonalPosF  =  0.27    ;up/down pos
amres@amJust            =  "CenterRight"

txid0 = gsn_create_text(wks,"1984-2009",txr)
;txid1 = gsn_create_text(wks,"~F0~Peak~F0~=~F0~12-13 yr~S~-1~N~",txr)
;anid0 =  gsn_add_annotation(plot2(8),txid0,amres)
;
txr@txFontColor  = "grey65"
txid1 = gsn_create_text(wks,"1979-2018",txr)
amres@amOrthogonalPosF  =  0.37    ;up/down pos
;anid1 =  gsn_add_annotation(plot2(8),txid1,amres)
;
txr@txFontColor  = "seagreen3"
txid2 = gsn_create_text(wks,"1979/2016 - 1950/2016",txr)
amres@amOrthogonalPosF  =  0.43    ;up/down pos
;amres@amParallelPosF  =   0.10    ;left/right pos
;anid2 =  gsn_add_annotation(plot(1),txid2,amres)
;===============================================================
;==============================================================
;=====================================================================
;=====================================================================
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
  ;resP@lbLabelStride		        = 5
  resP@lbLabelFont   		        = "Helvetica-Bold"     ; label font
  resP@lbTitleString                  	= "JAS precipitation (mm month~S~-1~N~)"
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
   
  gsn_panel(wks,plot2,(/3,3/),resP)     ; now draw as one plot
 
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
   ;res_P@lbLabelStride		        = 5
   res_P@lbLabelFont   		        = "Helvetica-Bold"     ; label font
   res_P@lbTitleString                  = "Standard deviations (mm month~S~-1~N~)"
  ;res_P@lbTitleString                  	= "SST trend (~S~o~N~C per 35-yr)"
   res_P@lbTopMarginF                     = 0.5
   res_P@gsnMaximize                      = True         ; large format
   res_P@gsnPaperOrientation              = "portrait"   ; force portrait
   res_P@gsnLeftString 			= ""
  ;res_P@txString          		= "SST trends: 1984-2008"
  ; res_P@txString          		= "JAS SST trends: 1984-2009"

   gsn_panel(wks,plotS(0:),(/3,3/),res_P)               ; create panel plots
;==============================================================      ;
;==============================================================
;=====================================================
;=====================================================
;=====================================================
;=====================================================
 frame(wks) 
;===============================================================================================================
;===============================================================================================================
end
