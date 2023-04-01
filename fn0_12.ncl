

begin
; ==============================================================
; User defined parameters that specify region of globe and
; ==============================================================
  latS   =  -50.
  latN   =  50. 
  lonL   = -180.
  lonR   =  180.


  p95 = 0.10
;************************************************
; variable and file handling
;************************************************
f  = addfile("/home/hnnamchi/work/geomar/wtrends/VP_timmean_925_200.nc","r")
m_vp = lonFlip(f->vp(0,:,:,:))
printVarSummary(m_vp)
printMinMax(m_vp,True)
;
;=====================================================================================
;=====================================================================================
;PC1+ years
diru = "/home/hnnamchi/work/geomar/wtrends/925_200hpa/undetrended/"
;=====================================================================================
;=====================================================================================
  fu  = addfile(diru+"ud_pc1_plus.nc","r")
  fv  = addfile(diru+"vd_pc1_plus.nc","r")
  fp  = addfile(diru+"vp_pc1_plus.nc","r")

  up  = lonFlip(fu->ud(:,:,:,:)) 
  vp  = lonFlip(fv->vd(:,:,:,:)) 
  pp  = lonFlip(fp->vp(:,:,:,:))

  delete(fu)
  delete(fv)
  delete(fp)
;
  printVarSummary(up)
  printVarSummary(vp)
  printVarSummary(pp)

  fu  = addfile(diru+"ud_pc1_minus.nc","r")
  fv  = addfile(diru+"vd_pc1_minus.nc","r")
  fp  = addfile(diru+"vp_pc1_minus.nc","r")

  um  = lonFlip(fu->ud(:,:,:,:)) 
  vm  = lonFlip(fv->vd(:,:,:,:)) 
  pm  = lonFlip(fp->vp(:,:,:,:))

  delete(fu)
  delete(fv)
  delete(fp)
;
  printVarSummary(um)
  printVarSummary(vm)
  printVarSummary(pm)
;

pc1uU = (dim_avg_n_Wrap(up,0)- dim_avg_n_Wrap(um,0))/2.
copy_VarCoords(um(0,:,:,:),pc1uU)                             ; copy coordinate arrays 
printVarSummary(pc1uU)
printMinMax(pc1uU,True)
;
pc1uV = (dim_avg_n_Wrap(vp,0)- dim_avg_n_Wrap(vm,0))/2.
copy_VarCoords(um(0,:,:,:),pc1uV)                             ; copy coordinate arrays 
printVarSummary(pc1uV)
printMinMax(pc1uV,True)
;
pc1uP = (dim_avg_n_Wrap(pp,0)- dim_avg_n_Wrap(pm,0))/2.
copy_VarCoords(pm(0,:,:,:),pc1uP)                             ; copy coordinate arrays 
printVarSummary(pc1uP)
printMinMax(pc1uP,True)
;=
; test for statistical significance

pc1uPd = pc1uP  ; Transfer metdata for plotting sig. values        

pc1uPd = ttest((dim_avg_n_Wrap(pp,0)),(dim_stddev_n_Wrap(pp,0))^2,dimsizes(pp(:,0,0,0))\
               ,(dim_avg_n_Wrap(pm,0)),(dim_stddev_n_Wrap(pm,0))^2,dimsizes(pm(:,0,0,0)),True, False)
pc1uPd@long_name = "Probability: difference between means"
printVarSummary(pc1uPd)
;
pc1uPd = where(abs(pc1uPd).lt.p95,pc1uP,pc1uP@_FillValue) ; maskout non-significant fields
print("==============================================================")  
printVarSummary(pc1uPd)
printMinMax(pc1uPd,True)
print("==============================================================")

;======================================================================
delete(up)
delete(vp)
delete(pp)
;
delete(um)
delete(vm)
delete(pm)
list_vars()





;=====================================================================================
;PC1+ years
diru = "/home/hnnamchi/work/geomar/wtrends/925_200hpa/undetrended/"
;=====================================================================================
;=====================================================================================
  fu  = addfile(diru+"ud_pc2_plus.nc","r")
  fv  = addfile(diru+"vd_pc2_plus.nc","r")
  fp  = addfile(diru+"vp_pc2_plus.nc","r")

  up  = lonFlip(fu->ud(:,:,:,:)) 
  vp  = lonFlip(fv->vd(:,:,:,:)) 
  pp  = lonFlip(fp->vp(:,:,:,:))

  delete(fu)
  delete(fv)
  delete(fp)
;
  printVarSummary(up)
  printVarSummary(vp)
  printVarSummary(pp)

  fu  = addfile(diru+"ud_pc2_minus.nc","r")
  fv  = addfile(diru+"vd_pc2_minus.nc","r")
  fp  = addfile(diru+"vp_pc2_minus.nc","r")

  um  = lonFlip(fu->ud(:,:,:,:)) 
  vm  = lonFlip(fv->vd(:,:,:,:)) 
  pm  = lonFlip(fp->vp(:,:,:,:))

  delete(fu)
  delete(fv)
  delete(fp)
;
  printVarSummary(um)
  printVarSummary(vm)
  printVarSummary(pm)
;

pc2uU = (dim_avg_n_Wrap(up,0)- dim_avg_n_Wrap(um,0))/2.
copy_VarCoords(um(0,:,:,:),pc2uU)                             ; copy coordinate arrays 
printVarSummary(pc2uU)
printMinMax(pc2uU,True)
;
pc2uV = (dim_avg_n_Wrap(vp,0)- dim_avg_n_Wrap(vm,0))/2.
copy_VarCoords(um(0,:,:,:),pc2uV)                             ; copy coordinate arrays 
printVarSummary(pc2uV)
printMinMax(pc2uV,True)
;
pc2uP = (dim_avg_n_Wrap(pp,0)- dim_avg_n_Wrap(pm,0))/2.
copy_VarCoords(pm(0,:,:,:),pc2uP)                             ; copy coordinate arrays 
printVarSummary(pc2uP)
printMinMax(pc2uP,True)
;=
; test for statistical significance

pc2uPd = pc2uP  ; Transfer metdata for plotting sig. values        

pc2uPd = ttest((dim_avg_n_Wrap(pp,0)),(dim_stddev_n_Wrap(pp,0))^2,dimsizes(pp(:,0,0,0))\
               ,(dim_avg_n_Wrap(pm,0)),(dim_stddev_n_Wrap(pm,0))^2,dimsizes(pm(:,0,0,0)),True, False)
pc2uPd@long_name = "Probability: difference between means"
printVarSummary(pc2uPd)
;
pc2uPd = where(abs(pc2uPd).lt.p95,pc2uP,pc2uP@_FillValue) ; maskout non-significant fields
print("==============================================================")  
printVarSummary(pc2uPd)
printMinMax(pc2uPd,True)
print("==============================================================")

;======================================================================
delete(up)
delete(vp)
delete(pp)
;
delete(um)
delete(vm)
delete(pm)
list_vars()



delete(diru)


























;========================================================================
;=====================================================================================
;PC1+ years
dird = "/home/hnnamchi/work/geomar/wtrends/925_200hpa/detrend/"
;=====================================================================================
;=====================================================================================
  fu  = addfile(dird+"ud_pc2_plus.nc","r")
  fv  = addfile(dird+"vd_pc2_plus.nc","r")
  fp  = addfile(dird+"vp_pc2_plus.nc","r")

  up  = lonFlip(fu->ud(:,:,:,:)) 
  vp  = lonFlip(fv->vd(:,:,:,:)) 
  pp  = lonFlip(fp->vp(:,:,:,:))

  delete(fu)
  delete(fv)
  delete(fp)
;
  printVarSummary(up)
  printVarSummary(vp)
  printVarSummary(pp)

  fu  = addfile(dird+"ud_pc2_minus.nc","r")
  fv  = addfile(dird+"vd_pc2_minus.nc","r")
  fp  = addfile(dird+"vp_pc2_minus.nc","r")

  um  = lonFlip(fu->ud(:,:,:,:)) 
  vm  = lonFlip(fv->vd(:,:,:,:)) 
  pm  = lonFlip(fp->vp(:,:,:,:))

  delete(fu)
  delete(fv)
  delete(fp)
;
  printVarSummary(um)
  printVarSummary(vm)
  printVarSummary(pm)
;

pc2dU = (dim_avg_n_Wrap(up,0)- dim_avg_n_Wrap(um,0))/2.
copy_VarCoords(um(0,:,:,:),pc2dU)                             ; copy coordinate arrays 
printVarSummary(pc2dU)
printMinMax(pc2dU,True)
;
pc2dV = (dim_avg_n_Wrap(vp,0)- dim_avg_n_Wrap(vm,0))/2.
copy_VarCoords(um(0,:,:,:),pc2dV)                             ; copy coordinate arrays 
printVarSummary(pc2dV)
printMinMax(pc2dV,True)
;
pc2dP = (dim_avg_n_Wrap(pp,0)- dim_avg_n_Wrap(pm,0))/2.
copy_VarCoords(pm(0,:,:,:),pc2dP)                             ; copy coordinate arrays 
printVarSummary(pc2dP)
printMinMax(pc2dP,True)
;=
; test for statistical significance

pc2dPd = pc2dP  ; Transfer metdata for plotting sig. values        

pc2dPd = ttest((dim_avg_n_Wrap(pp,0)),(dim_stddev_n_Wrap(pp,0))^2,dimsizes(pp(:,0,0,0))\
               ,(dim_avg_n_Wrap(pm,0)),(dim_stddev_n_Wrap(pm,0))^2,dimsizes(pm(:,0,0,0)),True, False)
pc2dPd@long_name = "Probability: difference between means"
printVarSummary(pc2dPd)
;
pc2dPd = where(abs(pc2dPd).lt.p95,pc2dP,pc2dP@_FillValue) ; maskout non-significant fields
print("==============================================================")  
printVarSummary(pc2dPd)
printMinMax(pc2dPd,True)
print("==============================================================")

;======================================================================
delete(up)
delete(vp)
delete(pp)
;
delete(um)
delete(vm)
delete(pm)
list_vars()

;=====================================================================================
;PC1+ years
dird = "/home/hnnamchi/work/geomar/wtrends/925_200hpa/detrend/"
;=====================================================================================
;=====================================================================================
  fu  = addfile(dird+"ud_pc1_plus.nc","r")
  fv  = addfile(dird+"vd_pc1_plus.nc","r")
  fp  = addfile(dird+"vp_pc1_plus.nc","r")

  up  = lonFlip(fu->ud(:,:,:,:)) 
  vp  = lonFlip(fv->vd(:,:,:,:)) 
  pp  = lonFlip(fp->vp(:,:,:,:))

  delete(fu)
  delete(fv)
  delete(fp)
;
  printVarSummary(up)
  printVarSummary(vp)
  printVarSummary(pp)

  fu  = addfile(dird+"ud_pc1_minus.nc","r")
  fv  = addfile(dird+"vd_pc1_minus.nc","r")
  fp  = addfile(dird+"vp_pc1_minus.nc","r")

  um  = lonFlip(fu->ud(:,:,:,:)) 
  vm  = lonFlip(fv->vd(:,:,:,:)) 
  pm  = lonFlip(fp->vp(:,:,:,:))

  delete(fu)
  delete(fv)
  delete(fp)
;
  printVarSummary(um)
  printVarSummary(vm)
  printVarSummary(pm)
;

pc1dU = (dim_avg_n_Wrap(up,0)- dim_avg_n_Wrap(um,0))/2.
copy_VarCoords(um(0,:,:,:),pc1dU)                             ; copy coordinate arrays 
printVarSummary(pc1dU)
printMinMax(pc1dU,True)
;
pc1dV = (dim_avg_n_Wrap(vp,0)- dim_avg_n_Wrap(vm,0))/2.
copy_VarCoords(um(0,:,:,:),pc1dV)                             ; copy coordinate arrays 
printVarSummary(pc1dV)
printMinMax(pc1dV,True)
;
pc1dP = (dim_avg_n_Wrap(pp,0)- dim_avg_n_Wrap(pm,0))/2.
copy_VarCoords(pm(0,:,:,:),pc1dP)                             ; copy coordinate arrays 
printVarSummary(pc1dP)
printMinMax(pc1dP,True)
;=
; test for statistical significance

pc1dPd = pc1dP  ; Transfer metdata for plotting sig. values        

pc1dPd = ttest((dim_avg_n_Wrap(pp,0)),(dim_stddev_n_Wrap(pp,0))^2,dimsizes(pp(:,0,0,0))\
               ,(dim_avg_n_Wrap(pm,0)),(dim_stddev_n_Wrap(pm,0))^2,dimsizes(pm(:,0,0,0)),True, False)
pc1dPd@long_name = "Probability: difference between means"
printVarSummary(pc1dPd)
;
pc1dPd = where(abs(pc1dPd).lt.p95,pc1dP,pc1dP@_FillValue) ; maskout non-significant fields
print("==============================================================")  
printVarSummary(pc1dPd)
printMinMax(pc1dPd,True)
print("==============================================================")

;======================================================================
delete(up)
delete(vp)
delete(pp)
;
delete(um)
delete(vm)
delete(pm)
list_vars()
;================================================================
; plot 
;================================================================

        wks  = gsn_open_wks("eps","fn0_12")          
        plot = new(8,graphic)     
        plotS = new(8,graphic)                       
  	res                      = True            
 	res@gsnFrame = False ;; Tell NCL not to plot the plot, just yet.
  	res@gsnDraw = False
  	res@cnFillOn             = True                
 	res@cnFillPalette        = "MPL_bwr"         
  	res@gsnAddCyclic         = False
  	res@cnLinesOn            = False             
  	res@mpLimitMode = "latlon"
	res@mpMinLatF = latS
	res@mpMaxLatF = latN
	res@mpMinLonF = lonL
	res@mpMaxLonF = lonR
       ;res@mpCenterLonF	= -90.
        res@pmTickMarkDisplayMode = "Always"
        ;res@mpFillDrawOrder      = "preDraw"
        res@mpFillOn 		= False
        res@mpGeophysicalLineColor  = "black" 
        res@mpGeophysicalLineThicknessF	= 1.0
	res@mpCenterLonF = (res@mpMaxLonF + res@mpMinLonF)*0.5
	;res@mpFillDrawOrder = "postdraw"
	;res@mpLandFillColor = (/1.0,1.0,1.0,0.0/) ; r,g,b,opacity
	;res@mpOceanFillColor = (/1.0,1.0,1.0,1.0/) ; r,g,b,opacity
	res@cnLevelSelectionMode = "ManualLevels"     
 	res@cnMinLevelValF       = -2.0                
 	res@cnMaxLevelValF       =  2.0                 
  	res@cnLevelSpacingF      =  0.2  
 	res@lbLabelBarOn         = False 
    
 	;res@gsnStringFontHeightF = 0.020
  	;res@tmXBLabelFontHeightF = 0.020             
  	;res@tmYLLabelFontHeightF = 0.020       


     res@gsnScalarContour	      = True
     res@vcRefAnnoOrthogonalPosF = -1.0             ; move ref vector up
     res@vcRefMagnitudeF         = 1.0             ; define vector ref mag
     res@vcRefAnnoString1          = "1.0 m s~S~-1~N~ "

     res@vcRefLengthF            = 0.050          
     res@vcGlyphStyle            = "LineArrow"   
     res@vcMinDistanceF          = 0.020
     res@vcLineArrowThicknessF   = 1.5
     res@vcLineArrowColor        = "black"           ; change vector color
     res@vcLineArrowHeadMaxSizeF = 0.15
;-----------------------------------------------------------------------------
  res1                      =   True
  res1@gsnDraw              = False        ; don't draw yet
  res1@gsnFrame             = False        ; don't advance frame yet
  res1@cnLevelSelectionMode = "ManualLevels"  ; set manual contour levels
  res1@cnMinLevelValF       =  -2.            ; set min contour level
  res1@cnMaxLevelValF       =  2.             ; set max contour level
  res1@cnLevelSpacingF      =  .1            ; set contour spacing  
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
;-----------------------------------------------------------------------------
  res2                      = True
  res2@gsnDraw              = False        ; don't draw yet
  res2@gsnFrame             = False        ; don't advance frame yet
  res2@cnLevelSelectionMode = "ManualLevels"  ; set manual contour levels
  res2@cnMinLevelValF       = -25.0            ; set min contour level
  res2@cnMaxLevelValF       =  25.0             ; set max contour level
  res2@cnLevelSpacingF      =  5.0            ; set contour spacing  
  res2@gsnAddCyclic         = False   
  res2@cnLinesOn            = True       ; True is default
  res2@cnLineLabelsOn       = True        ; True is default
  res2@cnLineColor	    = "seagreen3"
  res2@cnInfoLabelOn        = False
  res2@cnLineDashPattern    = 16
  res2@cnLineThicknessF     = 2.
  res2@gsnRightString   = ""
  res2@gsnLeftString   = ""
  ;res2@cnFillScaleF        = 0.7         ; add extra density
  ;res2@cnLineLabelDensityF =  -10.
  ;res2@cnFillDotSizeF       = 0.0001            ; increase dot size of contours
;----------------------------------------------------------------------------- 

;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
  opt = True
  opt@gsnShadeFillType = "pattern"        ; color is the default
  opt@gsnShadeLow = 17                     ; use fill pattern #4
  opt@gsnShadeHigh = 17                  ; use pattern #2   
  ;opt@gsnShadeMid = 2   
;-----------------------------------------------------------------------------
;----------------------------------------------------------------------------- 
;=====================================================================================
;=====================================================================================
;=====================================================================================
; bias
;=====================================================================================
res@gsnLeftString		= "a) (PC1+ minus PC1-)/2 (150 hPa)"
res@gsnRightString 		= "VP scaled by 1e6 (div. m/s)"	
;res@gsnCenterString      = "Chi scaled by 1e6"	
;plot(0) = gsn_csm_contour_map(wks,pc1uPd(0,:,:),res)
res@gsnLeftString	= ""
res@gsnRightString	= ""

res@gsnCenterStringFontHeightF   = 0.015
res@gsnCenterString  = "Trend + Variability"
plotA0 = gsn_csm_vector_scalar_map(wks,pc1uU(0,:,:),pc1uV(0,:,:),pc1uP(0,:,:),res)  ;
plotX0 = gsn_csm_contour(wks,m_vp(0,:,:),res2)
plotB0 = gsn_csm_contour(wks,pc1uPd(0,:,:),res1)
plotB0 = gsn_contour_shade(plotB0,p95,pc1uPd@_FillValue,opt) 

overlay(plotA0,plotB0)
;overlay(plotA0,plotX0)
plot(0) = plotA0
;
;flip pc2
pc2uU = -pc2uU
pc2uV = -pc2uV
pc2uP = -pc2uP
;
pc2dU = -pc2dU
pc2dV = -pc2dV
pc2dP = -pc2dP
;
;
plotA1 = gsn_csm_vector_scalar_map(wks,pc2uU(0,:,:),pc2uV(0,:,:),pc2uP(0,:,:),res)  ;
plotX1 = gsn_csm_contour(wks,m_vp(0,:,:),res2)
plotB1 = gsn_csm_contour(wks,pc2uPd(0,:,:),res1)
plotB1 = gsn_contour_shade(plotB1,p95,pc2uPd@_FillValue,opt)
 
overlay(plotA1,plotB1)
;overlay(plotA1,plotX1)
plot(1) = plotA1 
;
res@gsnCenterString  = "No trend"
plotA2 = gsn_csm_vector_scalar_map(wks,pc1dU(0,:,:),pc1dV(0,:,:),pc1dP(0,:,:),res)  ;
plotX2 = gsn_csm_contour(wks,m_vp(0,:,:),res2)
plotB2 = gsn_csm_contour(wks,pc1dPd(0,:,:),res1)
plotB2 = gsn_contour_shade(plotB2,p95,pc1dPd@_FillValue,opt) 

overlay(plotA2,plotB2)
;overlay(plotA2,plotX2)
plot(2) = plotA2


;res@gsnLeftString		= "b) (PC1+ minus PC1-)/2  (850 hPa)"
;plot(1) = gsn_csm_contour_map(wks,pc1uPd(1,:,:),res)

;
plotA3 = gsn_csm_vector_scalar_map(wks,pc2dU(0,:,:),pc2dV(0,:,:),pc2dP(0,:,:),res)  ;
plotX3 = gsn_csm_contour(wks,m_vp(0,:,:),res2)
plotB3 = gsn_csm_contour(wks,pc2dPd(0,:,:),res1)
plotB3 = gsn_contour_shade(plotB3,p95,pc2dPd@_FillValue,opt) 

overlay(plotA3,plotB3)
;overlay(plotA3,plotX3)
plot(3) = plotA3 

;================================================================
;=========================================================================
;=========================================================================
  txres5               = True
  txres5@txAngleF      = 0.          ; Rotate string clockwise 
  txres5@txFontHeightF = 0.020   ; Use same font height as left axis
  txres5@txFont                = "Helvetica-Bold"
  txres5@txFontColor           = "black"
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


 amres5@amParallelPosF   =  -0.55 ; 0.5 is the right edge of the plot, so
 amres5@amOrthogonalPosF =  -0.65    ; This is the center of the plot.
 

 tt = (/"(a)","(b)","(c)","(d)","(e)","(f)","(g)","(h)","(i)","(j)","(k)","(l)","(m)","(n)","(o)","(p)","(q)","(r)","(s)","(t)","(u)","(v)","(w)"/)
 create_tt = gsn_create_text(wks,tt,txres5);
tt_p0 = new(8,graphic)                ; create graphic array ; only needed if paneling
tt_p1 = new(8,graphic)
;---Attach the text
     do i = 0,3,1
      tt_p0(i) = gsn_add_annotation(plot(i),create_tt(i),amres5)
     ; tt_p1(i) = gsn_add_annotation(plot(i+2),create_tt(i+2),amres5)
     end do 
 delete(i)
;
;
;===============================================================
;==============================================================
  latEQ = (/ 20.,  20.,  0.,   0., 20./)
  lonEQ = (/-20., 20., 20., -20.,-20./)

;---Resources for the polyline
  pres0                  = True           ; polyline mods desired
  pres0@gsLineThicknessF = 2.0            ; line thickness   
  pres0@gsLineColor      = "white"         ; color of lines
  pres0@gsLineDashPattern = 2
  pres0@tfPolyDrawOrder   = "postDraw"

  dum0 = new(8,graphic)  
  
  ;---Attach the polyline
     do i = 0,3,1
      dum0(i) = gsn_add_polyline(wks,plot(i),lonEQ,latEQ,pres0)
     end do 
 delete(i)
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;===============================================================
;==============================================================
;================================================================


     res_P             = True 
     res_P@gsnDraw                          = True      ; don't draw yet
     res_P@gsnFrame                         = False        ; don't advance frame yet                       
     res_P@gsnMaximize = False 
     res_P@gsnPanelLabelBar= True   
     res_P@gsnPanelYWhiteSpacePercent      = 3.0    ; default is 1.0
     res_P@gsnPanelXWhiteSpacePercent      = 0.0    ; default is 1.0

     res_P@gsnPanelTop                      = 0.95
    res_P@gsnPanelBottom                   = 0.55
    res_P@gsnPanelLeft                     = 0.05
    res_P@gsnPanelRight                    = 0.95

     res_P@lbLabelFontHeightF =.010
     res_P@lbTitleFontHeightF	        = 0.010 
     res_P@lbLabelStride		        = 5
     res_P@lbLabelFont   		        = "Helvetica-Bold"     ; label font
    res_P@lbTitleString                  	= "Velocity potential (e~S~6~N~ m~S~2~N~s~S~-1~N~)"
    ;res_P@lbTitleString                  	= "SST trend (~S~o~N~C per 35-yr)"
     res_P@lbTopMarginF                     = 0.5 
    ; res_P@gsnPanelMainFontHeightF		=	0.020
    ; res_P@gsnPanelMainString		   	=	"Velocity potential and divergent winds at 150 hPa"                    
     gsn_panel(wks,plot(0:3),(/2,2/),res_P)           
	
;================================================================
;=====================================================================================
; 850 hPa

res@cnMinLevelValF       = -1.0                
res@cnMaxLevelValF       =  1.0                 
res@cnLevelSpacingF      =  0.1  

res@vcRefMagnitudeF         = 0.5             ; define vector ref mag
res@vcRefAnnoString1          = "0.5 m s~S~-1~N~ "


res@gsnCenterString  = "Trend + Variability"
plotC0 = gsn_csm_vector_scalar_map(wks,pc1uU(1,:,:),pc1uV(1,:,:),pc1uP(1,:,:),res)  ;
plotY0 = gsn_csm_contour(wks,m_vp(1,:,:),res2)
plotD0 = gsn_csm_contour(wks,pc1uPd(1,:,:),res1)
plotD0 = gsn_contour_shade(plotD0,p95,pc1uPd@_FillValue,opt) 
overlay(plotC0,plotD0)
;overlay(plotC0,plotY0)
plot(4) = plotC0
;
plotC1 = gsn_csm_vector_scalar_map(wks,pc2uU(1,:,:),pc2uV(1,:,:),pc2uP(1,:,:),res)  ;
plotY1 = gsn_csm_contour(wks,m_vp(1,:,:),res2)
plotD1 = gsn_csm_contour(wks,pc2uPd(1,:,:),res1)
plotD1 = gsn_contour_shade(plotD1,p95,pc2uPd@_FillValue,opt) 
overlay(plotC1,plotD1)
;overlay(plotC1,plotY1)
plot(5) = plotC1 
;
res@gsnCenterString  = "No trend"
plotC2 = gsn_csm_vector_scalar_map(wks,pc1dU(1,:,:),pc1dV(1,:,:),pc1dP(1,:,:),res)  ;
plotY2 = gsn_csm_contour(wks,m_vp(1,:,:),res2)
plotD2 = gsn_csm_contour(wks,pc1dPd(1,:,:),res1)
plotD2 = gsn_contour_shade(plotD2,p95,pc1dPd@_FillValue,opt) 
overlay(plotC2,plotD2)
;overlay(plotC2,plotY2)
plot(6) = plotC2


;res@gsnLeftString		= "b) (PC1+ minus PC1-)/2  (850 hPa)"
;plot(1) = gsn_csm_contour_map(wks,pc1uPd(1,:,:),res)

;
plotC3 = gsn_csm_vector_scalar_map(wks,pc2dU(1,:,:),pc2dV(1,:,:),pc2dP(1,:,:),res)  ;
plotY3 = gsn_csm_contour(wks,m_vp(1,:,:),res2)
plotD3 = gsn_csm_contour(wks,pc2dPd(1,:,:),res1)
plotD3 = gsn_contour_shade(plotD3,p95,pc2dPd@_FillValue,opt) 
overlay(plotC3,plotD3)
;overlay(plotC3,plotY3)
plot(7) = plotC3 
;=====================================================================================

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
  xpos0    = fspan(0.25, 0.65,dimsizes(var_names))

 do i = 0,dimsizes(labels0)-1,1
     gsn_text_ndc(wks,labels0(i),xpos0(i),0.98,txres)
  end do
delete(i)
delete(txres)
;=====================================================================
;=====================================================================
var_names1 = (/"925-hPa pressure level","200-hPa pressure level"/)
printVarSummary(var_names1)
print(var_names1)

  txres               = True         ; Text resources
  txres@txFontHeightF = 0.012
  txres@txJust        = "CenterLeft"
  txres@txFont                = "Helvetica-Bold"
  txres@txAngleF      =  90.

  labels1  = var_names1
  ypos1    = fspan(0.30, 0.70,dimsizes(var_names1))

 do i = 0,dimsizes(labels1)-1,1
     gsn_text_ndc(wks,labels1(i),0.035,ypos1(i),txres)
  end do
delete(i)
delete(txres)
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;=============================================================================
;=========================================================================
;=========================================================================
;=========================================================================
;---Attach the text
     do i = 4,7,1
      tt_p0(i) = gsn_add_annotation(plot(i),create_tt(i),amres5)
     end do 
 delete(i)
;
;
;---Attach the polyline
     do i = 4,7,1
      dum0(i) = gsn_add_polyline(wks,plot(i),lonEQ,latEQ,pres0)
     end do 
 delete(i)
;===============================================================
;==============================================================




     resP             = True 
     resP@gsnDraw                          = True      ; don't draw yet
     resP@gsnFrame                         = False        ; don't advance frame yet                       
     resP@gsnMaximize = False 
     resP@gsnPanelLabelBar= True   
     resP@gsnPanelYWhiteSpacePercent      = 3.0    ; default is 1.0
     resP@gsnPanelXWhiteSpacePercent      = 0.0    ; default is 1.0

     resP@gsnPanelTop                      = 0.60
     resP@gsnPanelBottom                   = 0.10
     resP@gsnPanelLeft                     = 0.05
     resP@gsnPanelRight                    = 0.95

     resP@lbLabelFontHeightF =.010
     resP@lbTitleFontHeightF	        = 0.010 
     resP@lbLabelStride		        = 5
     resP@lbLabelFont   		        = "Helvetica-Bold"     ; label font
     resP@lbTitleString                  	= "Velocity potential (e~S~6~N~ m~S~2~N~s~S~-1~N~)"
     ;resP@lbTitleString                  	= "Velocity potential (e~S~6~N~m/s)"
    ;resP@lbTitleString                  	= "SST trend (~S~o~N~C per 35-yr)"
     resP@lbTopMarginF                     = 0.5 
    ; resP@gsnPanelMainFontHeightF		=	0.020
    ; resP@gsnPanelMainString		   	=	"Velocity potential and divergent winds at 150 hPa"                    
     gsn_panel(wks,plot(4:7),(/2,2/),resP)           
	

;=====================================================================================
frame(wks)
print(xxxxxxxxxxxxxxxx)


















































































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
;============================================================================================================
;=================================================================
;=================================================================
;===================================== 
; ==============================================================
; Open the file: Read only the user specified period
; ==============================================================
  f      = addfile("/home/hyacinth/work/datasets/sst/OISST_sst.mnmean.nc", "r")

  TIME   = f->time
  YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
  iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

  sst    = short2flt(f->sst(iYYYY,:,:))
  printVarSummary(sst)                              ; variable overview
  ;print(xxxxxxxxxxx)

delete(f)
delete(TIME)
delete(YYYY)
delete(iYYYY)
 
   a    = addfile("$NCARG_ROOT/lib/ncarg/data/cdf/landsea.nc","r")
   lsdata = a->LSMASK
   lsm  = landsea_mask(lsdata,sst&lat,sst&lon)
   sst = mask(sst,lsm.eq.0,True)
; 
  delete(a)
  delete(lsm)  
; ==============================================================
  sst    = lonFlip(sst)
  printVarSummary(sst)                              ; note the longitude coord

;=========================================================================================
;===================================== 
; ==============================================================
; Open the file: Read only the user specified period
; ==============================================================
  f      = addfile("/home/hyacinth/work/datasets/era5/era5_wind_stress_1979_2018.nc", "r")

  TIME   = f->time
  YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
  iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

  era5u    = short2flt(f->metss(iYYYY,:,:))
  era5u!1 = "lat"
  era5u!2 = "lon"
  printVarSummary(era5u)                              ; variable overview

  era5v    = short2flt(f->mntss(iYYYY,:,:))
  era5v!1 = "lat"
  era5v!2 = "lon"
  printVarSummary(era5v)                              ; variable overview

  
  delete(f)
  delete(TIME)
  delete(YYYY)
  delete(iYYYY)
 
   lsm  = landsea_mask(lsdata,era5u&lat,era5u&lon)
   era5u = mask(era5u,lsm.eq.0,True)
   delete(lsm) 
;
   lsm  = landsea_mask(lsdata,era5v&lat,era5v&lon)
   era5v = mask(era5v,lsm.eq.0,True)
   delete(lsm)   
;
  era5u    = lonFlip(era5u)
  printVarSummary(era5u)                              ; note the longitude coord
;
  era5v    = lonFlip(era5v)
  printVarSummary(era5v)                              ; note the longitude coord
;=========================================================================================
;------------------------------------------------------------------
; ==============================================================
; compute desired global seasonal mean: month_to_season (contributed.ncl) 
; ==============================================================
  SST = month_to_season(sst,season)
  printVarSummary(SST)
  delete(sst)
;
  ERA5U = month_to_season(era5u,season)
  printVarSummary(ERA5U)
  delete(era5u)
;
  ERA5V = month_to_season(era5v,season)
  printVarSummary(ERA5V)
  delete(era5v)

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

pc1SSTd = where(abs(pc1SSTd).le.p95,pc1SST,pc1SST@_FillValue) ; Sig.u winds, where UWND or VWND is significanlt
print("==============================================================")  
printVarSummary(pc1SSTd)
printMinMax(pc1SSTd,True)
print("==============================================================")
;
;
;---------------------------------------------------
;
dimE = dimsizes(ERA5U)
printVarSummary(dimE)
;
pc1P_ERA5U_cases_maps  = new((/n_pc1P,dimE(1),dimE(2)/),float,ERA5U@_FillValue)
printVarSummary(pc1P_ERA5U_cases_maps)                
pc1P_ERA5U_cases_maps = ERA5U(valsP,:,:)
;
;
;
pc1N_ERA5U_cases_maps  = new((/n_pc1N,dimE(1),dimE(2)/),float,ERA5U@_FillValue)
printVarSummary(pc1N_ERA5U_cases_maps)                
pc1N_ERA5U_cases_maps = ERA5U(valsN,:,:)
;
;
pc1ERA5U = (dim_avg_n_Wrap(pc1P_ERA5U_cases_maps,0)- dim_avg_n_Wrap(pc1N_ERA5U_cases_maps,0))/2.
copy_VarCoords(ERA5U(time|0,lat|:,lon|:),pc1ERA5U)                             ; copy coordinate arrays 
printVarSummary(pc1ERA5U)
printMinMax(pc1ERA5U,True)
;
;
;===================================== 
pc1ERA5Ud = pc1ERA5U  ; Transfer metdata for plotting sig. values        

pc1ERA5Ud = ttest((dim_avg_n_Wrap(pc1P_ERA5U_cases_maps,0)),(dim_stddev_n_Wrap(pc1P_ERA5U_cases_maps,0))^2,n_pc1P\
               ,(dim_avg_n_Wrap(pc1N_ERA5U_cases_maps,0)),(dim_stddev_n_Wrap(pc1N_ERA5U_cases_maps,0))^2,n_pc1N,True, False)
pc1ERA5Ud@long_name = "Probability: difference between means"
printVarSummary(pc1ERA5Ud)
print("==============================================================")  
print("==============================================================")
;---------------------------------------------------
;
;
pc1P_ERA5V_cases_maps  = new((/n_pc1P,dimE(1),dimE(2)/),float,ERA5V@_FillValue)
printVarSummary(pc1P_ERA5V_cases_maps)                
pc1P_ERA5V_cases_maps = ERA5V(valsP,:,:)
;
;
;
pc1N_ERA5V_cases_maps  = new((/n_pc1N,dimE(1),dimE(2)/),float,ERA5V@_FillValue)
printVarSummary(pc1N_ERA5V_cases_maps)                
pc1N_ERA5V_cases_maps = ERA5V(valsN,:,:)
;
;
pc1ERA5V = (dim_avg_n_Wrap(pc1P_ERA5V_cases_maps,0)- dim_avg_n_Wrap(pc1N_ERA5V_cases_maps,0))/2.
copy_VarCoords(ERA5V(time|0,lat|:,lon|:),pc1ERA5V)                             ; copy coordinate arrays 
printVarSummary(pc1ERA5V)
printMinMax(pc1ERA5V,True)
;
;
;===================================== 
pc1ERA5Vd = pc1ERA5V  ; Transfer metdata for plotting sig. values        

pc1ERA5Vd = ttest((dim_avg_n_Wrap(pc1P_ERA5V_cases_maps,0)),(dim_stddev_n_Wrap(pc1P_ERA5V_cases_maps,0))^2,n_pc1P\
               ,(dim_avg_n_Wrap(pc1N_ERA5V_cases_maps,0)),(dim_stddev_n_Wrap(pc1N_ERA5V_cases_maps,0))^2,n_pc1N,True, False)
pc1ERA5Vd@long_name = "Probability: difference between means"
printVarSummary(pc1ERA5Vd)
print("==============================================================")  
print("==============================================================")
;
;
;
;     
pc1ERA5Ud  = where(pc1ERA5Ud.le.p95.or.pc1ERA5Vd.le.p95,pc1ERA5U,pc1ERA5U@_FillValue) 
printVarSummary(pc1ERA5Ud)
;++++++++++++++++++++++++++++++++++++++
pc1ERA5Vd  = where(pc1ERA5Ud.le.p95.or.pc1ERA5Vd.le.p95,pc1ERA5V,pc1ERA5V@_FillValue) 
printVarSummary(pc1ERA5Vd)
;------------------------------------------------------------------
;
;
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
delete(pc1P_ERA5V_cases_maps)
delete(pc1N_ERA5V_cases_maps)
delete(pc1P_ERA5U_cases_maps)
delete(pc1N_ERA5U_cases_maps)

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

pc2SSTd = where(abs(pc2SSTd).le.p95,pc2SST,pc2SST@_FillValue) ; Sig.u winds, where UWND or VWND is significanlt
print("==============================================================")  
printVarSummary(pc2SSTd)
printMinMax(pc2SSTd,True)
print("==============================================================")
;
;
;

;
;
;
;
pc2P_ERA5U_cases_maps  = new((/n_pc2P,dimE(1),dimE(2)/),float,ERA5U@_FillValue)
printVarSummary(pc2P_ERA5U_cases_maps)                
pc2P_ERA5U_cases_maps = ERA5U(valsP,:,:)
;
;
;
pc2N_ERA5U_cases_maps  = new((/n_pc2N,dimE(1),dimE(2)/),float,ERA5U@_FillValue)
printVarSummary(pc2N_ERA5U_cases_maps)                
pc2N_ERA5U_cases_maps = ERA5U(valsN,:,:)
;
;
pc2ERA5U = (dim_avg_n_Wrap(pc2P_ERA5U_cases_maps,0)- dim_avg_n_Wrap(pc2N_ERA5U_cases_maps,0))/2.
copy_VarCoords(ERA5U(time|0,lat|:,lon|:),pc2ERA5U)                             ; copy coordinate arrays 
printVarSummary(pc2ERA5U)
printMinMax(pc2ERA5U,True)
;
;
;===================================== 
pc2ERA5Ud = pc2ERA5U  ; Transfer metdata for plotting sig. values        

pc2ERA5Ud = ttest((dim_avg_n_Wrap(pc2P_ERA5U_cases_maps,0)),(dim_stddev_n_Wrap(pc2P_ERA5U_cases_maps,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_ERA5U_cases_maps,0)),(dim_stddev_n_Wrap(pc2N_ERA5U_cases_maps,0))^2,n_pc2N,True, False)
pc2ERA5Ud@long_name = "Probability: difference between means"
printVarSummary(pc2ERA5Ud)
print("==============================================================")  
print("==============================================================")
;---------------------------------------------------
;
;
pc2P_ERA5V_cases_maps  = new((/n_pc2P,dimE(1),dimE(2)/),float,ERA5V@_FillValue)
printVarSummary(pc2P_ERA5V_cases_maps)                
pc2P_ERA5V_cases_maps = ERA5V(valsP,:,:)
;
;
;
pc2N_ERA5V_cases_maps  = new((/n_pc2N,dimE(1),dimE(2)/),float,ERA5V@_FillValue)
printVarSummary(pc2N_ERA5V_cases_maps)                
pc2N_ERA5V_cases_maps = ERA5V(valsN,:,:)
;
;
pc2ERA5V = (dim_avg_n_Wrap(pc2P_ERA5V_cases_maps,0)- dim_avg_n_Wrap(pc2N_ERA5V_cases_maps,0))/2.
copy_VarCoords(ERA5V(time|0,lat|:,lon|:),pc2ERA5V)                             ; copy coordinate arrays 
printVarSummary(pc2ERA5V)
printMinMax(pc2ERA5V,True)
;
;
;===================================== 
pc2ERA5Vd = pc2ERA5V  ; Transfer metdata for plotting sig. values        

pc2ERA5Vd = ttest((dim_avg_n_Wrap(pc2P_ERA5V_cases_maps,0)),(dim_stddev_n_Wrap(pc2P_ERA5V_cases_maps,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_ERA5V_cases_maps,0)),(dim_stddev_n_Wrap(pc2N_ERA5V_cases_maps,0))^2,n_pc2N,True, False)
pc2ERA5Vd@long_name = "Probability: difference between means"
printVarSummary(pc2ERA5Vd)
;
;
;
;
;     
pc2ERA5Ud  = where(pc2ERA5Ud.le.p95.or.pc2ERA5Vd.le.p95,pc2ERA5U,pc2ERA5U@_FillValue) 
printVarSummary(pc2ERA5Ud)
;++++++++++++++++++++++++++++++++++++++
pc2ERA5Vd  = where(pc2ERA5Ud.le.p95.or.pc2ERA5Vd.le.p95,pc2ERA5V,pc2ERA5V@_FillValue) 
printVarSummary(pc2ERA5Vd)
;------------------------------------------------------------------
;
;
print("==============================================================")  
print("==============================================================")
delete(pc2P_cases_maps)
delete(pc2N_cases_maps)
delete(pc2)
delete(valsP)
delete(valsN)
delete(pc2P_cases)
delete(pc2N_cases)
delete(n_pc2P)
delete(n_pc2N)
delete(pc2P_ERA5U_cases_maps)
delete(pc2P_ERA5V_cases_maps)
delete(pc2N_ERA5U_cases_maps)
delete(pc2N_ERA5V_cases_maps)
list_vars()
;
;
;
;
;
;
;
;
;---------------------------------------------------
; =================================================================
;-------------------------------------------------------------------------
;Remove the linear trends
;& repeat the analysis

SST = dtrend_msg_n(SST&time,SST,True,False,0)
ERA5U = dtrend_msg_n(ERA5U&time,ERA5U,True,False,0)
ERA5V = dtrend_msg_n(ERA5V&time,ERA5V,True,False,0)
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
;
;
pc1SST_nt = (dim_avg_n_Wrap(pc1P_cases_maps,0)- dim_avg_n_Wrap(pc1N_cases_maps,0))/2.
copy_VarCoords(SST(time|0,lat|:,lon|:),pc1SST_nt)                             ; copy coordinate arrays 
printVarSummary(pc1SST_nt)
printMinMax(pc1SST_nt,True)
;
;
;===================================== 
pc1SST_ntd = pc1SST_nt  ; Transfer metdata for plotting sig. values        

pc1SST_ntd = ttest((dim_avg_n_Wrap(pc1P_cases_maps,0)),(dim_stddev_n_Wrap(pc1P_cases_maps,0))^2,n_pc1P\
               ,(dim_avg_n_Wrap(pc1N_cases_maps,0)),(dim_stddev_n_Wrap(pc1N_cases_maps,0))^2,n_pc1N,True, False)
pc1SST_ntd@long_name = "Probability: difference between means"
printVarSummary(pc1SST_ntd)

pc1SST_ntd = where(abs(pc1SST_ntd).le.p95,pc1SST_nt,pc1SST_nt@_FillValue) ; Sig.u winds, where UWND or VWND is significanlt
print("==============================================================")  
printVarSummary(pc1SST_ntd)
printMinMax(pc1SST_ntd,True)
print("==============================================================")
;
;
;
;
;
;
;

;
;
;
;
pc1P_ERA5U_cases_maps  = new((/n_pc1P,dimE(1),dimE(2)/),float,ERA5U@_FillValue)
printVarSummary(pc1P_ERA5U_cases_maps)                
pc1P_ERA5U_cases_maps = ERA5U(valsP,:,:)
;
;
;
pc1N_ERA5U_cases_maps  = new((/n_pc1N,dimE(1),dimE(2)/),float,ERA5U@_FillValue)
printVarSummary(pc1N_ERA5U_cases_maps)                
pc1N_ERA5U_cases_maps = ERA5U(valsN,:,:)
;
;
pc1ERA5U_nt = (dim_avg_n_Wrap(pc1P_ERA5U_cases_maps,0)- dim_avg_n_Wrap(pc1N_ERA5U_cases_maps,0))/2.
copy_VarCoords(ERA5U(time|0,lat|:,lon|:),pc1ERA5U_nt)                             ; copy coordinate arrays 
printVarSummary(pc1ERA5U_nt)
printMinMax(pc1ERA5U_nt,True)
;
;
;===================================== 
pc1ERA5U_ntd = pc1ERA5U_nt  ; Transfer metdata for plotting sig. values        

pc1ERA5U_ntd = ttest((dim_avg_n_Wrap(pc1P_ERA5U_cases_maps,0)),(dim_stddev_n_Wrap(pc1P_ERA5U_cases_maps,0))^2,n_pc1P\
               ,(dim_avg_n_Wrap(pc1N_ERA5U_cases_maps,0)),(dim_stddev_n_Wrap(pc1N_ERA5U_cases_maps,0))^2,n_pc1N,True, False)
pc1ERA5U_ntd@long_name = "Probability: difference between means"
printVarSummary(pc1ERA5U_ntd)
print("==============================================================")  
print("==============================================================")
;---------------------------------------------------
;
;
pc1P_ERA5V_cases_maps  = new((/n_pc1P,dimE(1),dimE(2)/),float,ERA5V@_FillValue)
printVarSummary(pc1P_ERA5V_cases_maps)                
pc1P_ERA5V_cases_maps = ERA5V(valsP,:,:)
;
;
;
pc1N_ERA5V_cases_maps  = new((/n_pc1N,dimE(1),dimE(2)/),float,ERA5V@_FillValue)
printVarSummary(pc1N_ERA5V_cases_maps)                
pc1N_ERA5V_cases_maps = ERA5V(valsN,:,:)
;
;
pc1ERA5V_nt = (dim_avg_n_Wrap(pc1P_ERA5V_cases_maps,0)- dim_avg_n_Wrap(pc1N_ERA5V_cases_maps,0))/2.
copy_VarCoords(ERA5V(time|0,lat|:,lon|:),pc1ERA5V_nt)                             ; copy coordinate arrays 
printVarSummary(pc1ERA5V_nt)
printMinMax(pc1ERA5V_nt,True)
;
;
;===================================== 
pc1ERA5V_ntd = pc1ERA5V_nt  ; Transfer metdata for plotting sig. values        

pc1ERA5V_ntd = ttest((dim_avg_n_Wrap(pc1P_ERA5V_cases_maps,0)),(dim_stddev_n_Wrap(pc1P_ERA5V_cases_maps,0))^2,n_pc1P\
               ,(dim_avg_n_Wrap(pc1N_ERA5V_cases_maps,0)),(dim_stddev_n_Wrap(pc1N_ERA5V_cases_maps,0))^2,n_pc1N,True, False)
pc1ERA5V_ntd@long_name = "Probability: difference between means"
printVarSummary(pc1ERA5V_ntd)
;
;
;
pc1ERA5U_ntd  = where(pc1ERA5U_ntd.le.p95.or.pc1ERA5V_ntd.le.p95,pc1ERA5U_nt,pc1ERA5U_nt@_FillValue) 
printVarSummary(pc1ERA5U_ntd)
;++++++++++++++++++++++++++++++++++++++
pc1ERA5V_ntd  = where(pc1ERA5U_ntd.le.p95.or.pc1ERA5V_ntd.le.p95,pc1ERA5V_nt,pc1ERA5V_nt@_FillValue) 
printVarSummary(pc1ERA5V_ntd)
;------------------------------------------------------------------
print("==============================================================")  
print("==============================================================")
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
;
;
;
;
;
;
;
;
;
;
;
;
;
;
;
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
;
;
;===================================== 
pc2SST_ntd = pc2SST_nt  ; Transfer metdata for plotting sig. values        

pc2SST_ntd = ttest((dim_avg_n_Wrap(pc2P_cases_maps,0)),(dim_stddev_n_Wrap(pc2P_cases_maps,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_cases_maps,0)),(dim_stddev_n_Wrap(pc2N_cases_maps,0))^2,n_pc2N,True, False)
pc2SST_ntd@long_name = "Probability: difference between means"
printVarSummary(pc2SST_ntd)

pc2SST_ntd = where(abs(pc2SST_ntd).le.p95,pc2SST_nt,pc2SST_nt@_FillValue) ; Sig.u winds, where UWND or VWND is significanlt
print("==============================================================")  
printVarSummary(pc2SST_ntd)
printMinMax(pc2SST_ntd,True)
print("==============================================================")
;
;
;
;
;
;
;
;
;
;
;
pc2P_ERA5U_cases_maps  = new((/n_pc2P,dimE(1),dimE(2)/),float,ERA5U@_FillValue)
printVarSummary(pc2P_ERA5U_cases_maps)                
pc2P_ERA5U_cases_maps = ERA5U(valsP,:,:)
;
;
;
pc2N_ERA5U_cases_maps  = new((/n_pc2N,dimE(1),dimE(2)/),float,ERA5U@_FillValue)
printVarSummary(pc2N_ERA5U_cases_maps)                
pc2N_ERA5U_cases_maps = ERA5U(valsN,:,:)
;
;
pc2ERA5U_nt = (dim_avg_n_Wrap(pc2P_ERA5U_cases_maps,0)- dim_avg_n_Wrap(pc2N_ERA5U_cases_maps,0))/2.
copy_VarCoords(ERA5U(time|0,lat|:,lon|:),pc2ERA5U_nt)                             ; copy coordinate arrays 
printVarSummary(pc2ERA5U_nt)
printMinMax(pc2ERA5U_nt,True)
;
;
;===================================== 
pc2ERA5U_ntd = pc2ERA5U_nt  ; Transfer metdata for plotting sig. values        

pc2ERA5U_ntd = ttest((dim_avg_n_Wrap(pc2P_ERA5U_cases_maps,0)),(dim_stddev_n_Wrap(pc2P_ERA5U_cases_maps,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_ERA5U_cases_maps,0)),(dim_stddev_n_Wrap(pc2N_ERA5U_cases_maps,0))^2,n_pc2N,True, False)
pc2ERA5U_ntd@long_name = "Probability: difference between means"
printVarSummary(pc2ERA5U_ntd)
print("==============================================================")  
print("==============================================================")
;---------------------------------------------------
;
;
pc2P_ERA5V_cases_maps  = new((/n_pc2P,dimE(1),dimE(2)/),float,ERA5V@_FillValue)
printVarSummary(pc2P_ERA5V_cases_maps)                
pc2P_ERA5V_cases_maps = ERA5V(valsP,:,:)
;
;
;
pc2N_ERA5V_cases_maps  = new((/n_pc2N,dimE(1),dimE(2)/),float,ERA5V@_FillValue)
printVarSummary(pc2N_ERA5V_cases_maps)                
pc2N_ERA5V_cases_maps = ERA5V(valsN,:,:)
;
;
pc2ERA5V_nt = (dim_avg_n_Wrap(pc2P_ERA5V_cases_maps,0)- dim_avg_n_Wrap(pc2N_ERA5V_cases_maps,0))/2.
copy_VarCoords(ERA5V(time|0,lat|:,lon|:),pc2ERA5V_nt)                             ; copy coordinate arrays 
printVarSummary(pc2ERA5V_nt)
printMinMax(pc2ERA5V_nt,True)
;
;
;===================================== 
pc2ERA5V_ntd = pc2ERA5V_nt  ; Transfer metdata for plotting sig. values        

pc2ERA5V_ntd = ttest((dim_avg_n_Wrap(pc2P_ERA5V_cases_maps,0)),(dim_stddev_n_Wrap(pc2P_ERA5V_cases_maps,0))^2,n_pc2P\
               ,(dim_avg_n_Wrap(pc2N_ERA5V_cases_maps,0)),(dim_stddev_n_Wrap(pc2N_ERA5V_cases_maps,0))^2,n_pc2N,True, False)
pc2ERA5V_ntd@long_name = "Probability: difference between means"
printVarSummary(pc2ERA5V_ntd)
;
;
;
;
;     
pc2ERA5U_ntd  = where(pc2ERA5U_ntd.le.p95.or.pc2ERA5V_ntd.le.p95,pc2ERA5U_nt,pc2ERA5U_nt@_FillValue) 
printVarSummary(pc2ERA5U_ntd)
;++++++++++++++++++++++++++++++++++++++
pc2ERA5V_ntd  = where(pc2ERA5U_ntd.le.p95.or.pc2ERA5V_ntd.le.p95,pc2ERA5V_nt,pc2ERA5V_nt@_FillValue) 
printVarSummary(pc2ERA5V_ntd)
;------------------------------------------------------------------
;
;
print("==============================================================")  
print("==============================================================")
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
delete(pc2N_ERA5U_cases_maps)
delete(pc2N_ERA5V_cases_maps)
list_vars()
;
;
;
;
;
;
;
;
;==================================================================
;==================================================================
;============================================================
;============================================================
; PLOTS
;============================================================
  wks = gsn_open_wks("eps","fn0_3c")         ; send graphics to PNG file
  plot = new(4,graphic)                ; create graphic array
                                          ; only needed if paneling
  plotS = new(4,graphic)                ; create graphic array
; EOF patterns

  res                      = True         
  res@gsnDraw              = False        ; don't draw yet
  res@gsnFrame             = False        ; don't advance frame yet
  res@mpProjection    	   = "Robinson"       ; choose projection
  res@cnLevelSelectionMode = "ManualLevels"  ; set manual contour levels
  res@cnMinLevelValF       = -1.            ; set min contour level
  res@cnMaxLevelValF       =  1.             ; set max contour level
  res@cnLevelSpacingF      =  0.1            ; set contour spacing  
 
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
  res@mpFillDrawOrder      = "postDraw"

  res@gsnAddCyclic         = True
  res@cnFillOn             = True         ; turn on color fill
  res@cnLinesOn            = False        ; True is default
  res@cnLineLabelsOn       = False        ; True is default
  res@cnMissingValFillColor = "grey" ; comment this line out 
  ;res@cnFillPalette        = "BlueWhiteOrangeRed"  
  res@mpOceanFillColor        = "white"
  res@mpGeophysicalLineColor  = "grey" 
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

  res@vcRefAnnoOrthogonalPosF = -1.0             ; move ref vector up
  res@vcRefMagnitudeF         = 0.01             ; define vector ref mag
  res@vcRefAnnoString1          = "0.01 N m~S~-2~N~ "
  res@vcRefLengthF            = 0.045            ; define length of vec ref
  res@vcGlyphStyle            = "CurlyVector"    ; turn on curly vectors
  res@vcMinDistanceF          = 0.045
  res@vcLineArrowThicknessF   = 1.
  res@vcLineArrowColor        = "blue"           ; change vector color
  res@gsnScalarContour	      = True
  res@vcLineArrowHeadMaxSizeF = 0.05
  ;res@vcLineArrowHeadMinSizeF = 0.01
  ;res@vcMaxLevelCount		= 70
  
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
  res1@cnMinLevelValF       =  -2.            ; set min contour level
  res1@cnMaxLevelValF       =  2.             ; set max contour level
  res1@cnLevelSpacingF      =  .1            ; set contour spacing  
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
  opt@gsnShadeLow = 17                     ; use fill pattern #4
 ; opt@gsnShadeHigh = 17                  ; use pattern #2   
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
   ;plotA0 = gsn_csm_contour_map(wks,pc1SST,res)
   plotA0 = gsn_csm_vector_scalar_map(wks,pc1ERA5U,pc1ERA5V,pc1SST,res)  ; 
   plotS0 = gsn_csm_contour(wks,pc1SSTd,res1)
   plotS0 = gsn_contour_shade(plotS0,pc1SSTd@_FillValue,p95,opt)
   overlay(plotA0,plotS0)
   plot(0) = plotA0
;
  ; plotA1 = gsn_csm_contour_map(wks,pc2SST,res)
   plotA1 = gsn_csm_vector_scalar_map(wks,pc2ERA5U,pc2ERA5V,pc2SST,res)  ; 
   plotS1 = gsn_csm_contour(wks,pc2SSTd,res1)
   plotS1 = gsn_contour_shade(plotS1,pc2SSTd@_FillValue,p95,opt)
   overlay(plotA1,plotS1)
   plot(1) = plotA1

 ; No trends
   res@gsnCenterString  = "No trend"
   ;plotA2 = gsn_csm_contour_map(wks,pc1SST_nt,res)
   plotA2 = gsn_csm_vector_scalar_map(wks,pc1ERA5U_nt,pc1ERA5V_nt,pc1SST_nt,res)  ; 
   plotS2 = gsn_csm_contour(wks,pc1SST_ntd,res1)
   plotS2 = gsn_contour_shade(plotS2,pc1SST_ntd@_FillValue,p95,opt)
   overlay(plotA2,plotS2)
   plot(2) = plotA2
;
  
   ;plotA3 = gsn_csm_contour_map(wks,pc2SST_nt,res)
   plotA3 = gsn_csm_vector_scalar_map(wks,pc2ERA5U_nt,pc2ERA5V_nt,pc2SST_nt,res)  ; 
   plotS3 = gsn_csm_contour(wks,pc2SST_ntd,res1)
   plotS3 = gsn_contour_shade(plotS3,pc2SST_ntd@_FillValue,p95,opt)
   overlay(plotA3,plotS3)
   plot(3) = plotA3

;
;-----------------------------------------------------------------------------
;-----------------------------------------------------------------------------
;---------------------------------------------------------------------
var_names = (/"Sahel wetting","Gunea Coast drying"/)
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
  resP@gsnPanelLabelBar    	        = True        ; add common colorbar
  resP@gsnPanelYWhiteSpacePercent      	= 3.0    ; default is 1.0
  resP@gsnPanelXWhiteSpacePercent      	= 0.0    ; default is 1.0
  resP@gsnPanelTop                      = 1.0
  resP@gsnPanelBottom                   = 0.25
  resP@gsnPanelLeft                     = 0.01
  resP@gsnPanelRight                    = 0.99
  resP@lbTitleFontHeightF	        = 0.010 
  resP@lbLabelFontHeightF               = 0.010
 ; resP@lbLabelStride		        = 5
  resP@lbLabelFont   		        = "Helvetica-Bold"     ; label font
  resP@lbTitleString                  	= "SST anomaly (K)"
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
   
  gsn_panel(wks,plot(0:),(/2,2/),resP)     ; now draw as one plot
 
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

