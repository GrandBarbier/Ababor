using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Wizama.Hardware.Antenna;
using Wizama.Hardware.Light;

public class NFCCard : MonoBehaviour
{
    private LIGHT_INDEX lightIndex;
    private LIGHT_COLOR lightColor;
    private bool keepOthersColorized;


    void Start()
    {
        // NFCController.StartPolling( NFC_DEVICE_ID.ANTENNA_1, NFC_DEVICE_ID.ANTENNA_8, NFC_DEVICE_ID.ANTENNA_14, NFC_DEVICE_ID.ANTENNA_21);
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_1, LIGHT_COLOR.COLOR_RED);
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_2, LIGHT_COLOR.COLOR_RED);
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_3, LIGHT_COLOR.COLOR_RED);
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_4, LIGHT_COLOR.COLOR_RED);
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_5, LIGHT_COLOR.COLOR_RED);
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_6, LIGHT_COLOR.COLOR_RED);

        LightController.GetColor(LIGHT_INDEX.LIGHT_1);
        
        
        
        
    }   
    
    void OnDisable()  {  
        NFCController.StopPolling();  
    }   
    
    void FixedUpdate()  { 
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_1, LIGHT_COLOR.COLOR_RED);
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_2, LIGHT_COLOR.COLOR_RED);
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_3, LIGHT_COLOR.COLOR_RED);
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_4, LIGHT_COLOR.COLOR_RED);
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_5, LIGHT_COLOR.COLOR_RED);
        LightController.ColorizeOne(LIGHT_INDEX.LIGHT_6, LIGHT_COLOR.COLOR_RED);
       
        
        // List<NFCTag> antenna1Tags = NFCController.GetTags(NFC_DEVICE_ID.ANTENNA_1);   
       //  foreach (NFCTag tag in antenna1Tags)  
       //      Debug.Log(tag.Data + " placed on antenna 1");   
       //  
       //  List<NFCTag>[] allAntennaTags = NFCController.GetTags();   
       //  int count = 0;  
       //  foreach (List<NFCTag> Tags in allAntennaTags)  
       //      count += Tags.Count;   
       //      
       //  Debug.Log("There is " + count + " tags detected in total");
    } 
}
