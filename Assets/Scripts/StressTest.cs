using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Wizama.Hardware.Antenna;

public class StressTest : MonoBehaviour
{
    public Transform spawnPoint;
    public GameObject sphere;
    
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
        NFCController.StartPolling( NFC_DEVICE_ID.ANTENNA_1, NFC_DEVICE_ID.ANTENNA_8, NFC_DEVICE_ID.ANTENNA_14, NFC_DEVICE_ID.ANTENNA_21);
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
            GetObjectStats();
        }  
        
        
        List<NFCTag>[] allAntennaTags = NFCController.GetTags();   
        int count = 0;  
        foreach (List<NFCTag> Tags in allAntennaTags)  
            count += Tags.Count;
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
        if (Show_Tris){
            string trisdisplay = tris.ToString ("#,##0 tris");
            GUILayout.Label(trisdisplay);
        }
        if (Show_Verts){
            string vertsdisplay = verts.ToString ("#,##0 verts");
            GUILayout.Label(vertsdisplay);
        }
        GUILayout.EndArea();
    }
 
    void GetObjectStats() {
        verts = 0;
        tris = 0;
        GameObject[] ob = FindObjectsOfType(typeof(GameObject)) as GameObject[];
        foreach (GameObject obj in ob) {
            GetObjectStats(obj);
        }
    }
 
    void GetObjectStats(GameObject obj) {
        Component[] filters;
        filters = obj.GetComponentsInChildren<MeshFilter>();
        foreach( MeshFilter f  in filters )
        {
            tris += f.sharedMesh.triangles.Length/3;
            verts += f.sharedMesh.vertexCount;
        }
    }

    public void SpawnSphere()
    {
        Instantiate(sphere, spawnPoint.position, Quaternion.identity);
    }
    
    public void SpawnSphere10()
    {
        for (int i = 0; i < 10; i++)
        {
            Instantiate(sphere, spawnPoint.position, Quaternion.identity); 
        }
    }
    
    public void SpawnSphere100()
    {
        for (int i = 0; i < 100; i++)
        {
            Instantiate(sphere, spawnPoint.position, Quaternion.identity); 
        }
    }
    
    
    void OnDisable()  {  
        NFCController.StopPolling();  
    }    
    
    private void OnNewTagDetected(NFC_DEVICE_ID _device, NFCTag _tag)  {  
        SpawnSphere();
    }    
    
    private void OnTagRemoveDetected(NFC_DEVICE_ID _device, NFCTag _tag)  {  
        SpawnSphere();  
    } 
}
