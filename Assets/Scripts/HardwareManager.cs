using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Wizama.Hardware.Antenna;
using Wizama.Hardware.Light;

public class HardwareManager : MonoBehaviour
{
    public LIGHT_INDEX[] lightsP1;
    public LIGHT_INDEX[] lightsP2;
    public LIGHT_INDEX[] lightsP3;
    public LIGHT_INDEX[] lightsP4;

    public NFC_DEVICE_ID[] antenna;

    public Text text;
    
    
    void Start()
    {
        NFCController.OnNewTag = OnNewTagDetected;  
        NFCController.OnTagRemoved = OnTagRemoveDetected;    
        NFCController.StartPollingAsync(antenna);  
    }
    
    void OnDisable()  
    {
        NFCController.StopPolling();  
    }
    
    public void Colorize()
    {
        LightController.Colorize(lightsP1, LIGHT_COLOR.COLOR_RED, true);
        LightController.Colorize(lightsP2, LIGHT_COLOR.COLOR_BLUE, true);
        LightController.Colorize(lightsP3, LIGHT_COLOR.COLOR_YELLOW, true);
        LightController.Colorize(lightsP4, LIGHT_COLOR.COLOR_GREEN, true);
    }
    
    public void ShutLights()
    {
        LightController.ShutdownAllLights();
    }
    
    private void OnNewTagDetected(NFC_DEVICE_ID _device, NFCTag _tag)  
    {  
        text.text = _tag.Data + " " + _tag.Type.ToString() + " added on " + _device.ToString();
    }    
    
    private void OnTagRemoveDetected(NFC_DEVICE_ID _device, NFCTag _tag)  
    {
        text.text = _tag.Data + " " + _tag.Type.ToString() + " removed from " + _device.ToString();
    }
}