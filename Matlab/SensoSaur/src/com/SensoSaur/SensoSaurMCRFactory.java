/*
 * MATLAB Compiler: 4.16 (R2011b)
 * Date: Tue Aug 20 23:16:51 2013
 * Arguments: "-B" "macro_default" "-W" "java:com.SensoSaur,visualize" "-T" "link:lib" 
 * "-d" "D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\SensoSaur\\src" "-w" 
 * "enable:specified_file_mismatch" "-w" "enable:repeated_file" "-w" 
 * "enable:switch_ignored" "-w" "enable:missing_lib_sentinel" "-w" "enable:demo_license" 
 * "-v" 
 * "class{visualize:D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\annotateComments.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\clusterWifi.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\combineClusters.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\correctLocation.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\correctSeed.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\detectElevator.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\detectVariance.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\getAnalytics.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\getClusters.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\getLocation.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\getLocationClusters.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\getSeedLandmarks.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\getStableClusters.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\heatMap.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\kMeansInitAndStart.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\kmeansMod.m,C:\\Users\\Dell\\Desktop\\makeSqr.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\movingstd.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\movingvar.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\optKinKmeans.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\parsedata.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\readComments.m,D:\\Documents\\GSoC\\landmarkerGSoC\\Matlab\\stabilize.m}" 
 */

package com.SensoSaur;

import com.mathworks.toolbox.javabuilder.*;
import com.mathworks.toolbox.javabuilder.internal.*;

/**
 * <i>INTERNAL USE ONLY</i>
 */
public class SensoSaurMCRFactory
{
   
    
    /** Component's uuid */
    private static final String sComponentId = "SensoSaur_8BC6B2E09CEC33E9E13F1BFF3F6FD806";
    
    /** Component name */
    private static final String sComponentName = "SensoSaur";
    
   
    /** Pointer to default component options */
    private static final MWComponentOptions sDefaultComponentOptions = 
        new MWComponentOptions(
            MWCtfExtractLocation.EXTRACT_TO_CACHE, 
            new MWCtfClassLoaderSource(SensoSaurMCRFactory.class)
        );
    
    
    private SensoSaurMCRFactory()
    {
        // Never called.
    }
    
    public static MWMCR newInstance(MWComponentOptions componentOptions) throws MWException
    {
        if (null == componentOptions.getCtfSource()) {
            componentOptions = new MWComponentOptions(componentOptions);
            componentOptions.setCtfSource(sDefaultComponentOptions.getCtfSource());
        }
        return MWMCR.newInstance(
            componentOptions, 
            SensoSaurMCRFactory.class, 
            sComponentName, 
            sComponentId,
            new int[]{7,16,0}
        );
    }
    
    public static MWMCR newInstance() throws MWException
    {
        return newInstance(sDefaultComponentOptions);
    }
}
