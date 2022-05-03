using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StressTest : MonoBehaviour
{
    public bool Show_Stats;
    public bool Show_FPS;
    public bool Show_Tris;
    public bool Show_Verts;
    public static int verts;
    public static int tris;
   
    public  float updateInterval = 0.5F;
 
    private float accum   = 0; // FPS accumulated over the interval
    private int   frames  = 0; // Frames drawn over the interval
    private float timeleft; // Left time for current interval
    public float fps;
 
    // Use this for initialization
    void Start () {
        timeleft = updateInterval;
        bool supported = SystemInfo.supportsComputeShaders && SystemInfo.maxComputeBufferInputsVertex != 0;
        Debug.Log("is supported ? : " + supported);
    }
   
    // Update is called once per frame
    void Update () {
        timeleft -= Time.deltaTime;
        accum += Time.timeScale/Time.deltaTime;
        ++frames;
       
        if( timeleft <= 0.0 )
        {
            // display two fractional digits (f2 format)
            fps = accum/frames;
            string format = System.String.Format("{0:F2} FPS",fps);
            //  DebugConsole.Log(format,level);
                timeleft = updateInterval;
             accum = 0.0F;
             frames = 0;
        }
    }
   
    void OnGUI() {
        if(Show_Stats)
        ShowStatistics();
    }
   
    void ShowStatistics(){
        GUILayout.BeginArea( new Rect(150, 50, 100, 500));
        if (Show_FPS){
            string fpsdisplay = fps.ToString ("#,##0 fps");
            GUILayout.Label(fpsdisplay);
        }
        GUILayout.EndArea();
    }
}
