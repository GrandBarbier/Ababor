using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using Wizama.Hardware.Antenna;
using Wizama.Hardware.Light;
using Debug = UnityEngine.Debug;

public class HardwareManager : MonoBehaviour
{
    public LIGHT_INDEX[] lightsP1;
    public LIGHT_INDEX[] lightsP2;
    public LIGHT_INDEX[] lightsP3;
    public LIGHT_INDEX[] lightsP4;

    public NFC_DEVICE_ID[] antennaP1;
    public NFC_DEVICE_ID[] antennaP2;
    public NFC_DEVICE_ID[] antennaP3;
    public NFC_DEVICE_ID[] antennaP4;
    
    public GameplayManager gameplayManager;
    
    [SerializeField] 
    private bool canNFC;

    public int nbPlayers;
    
    public Text text;
    
    private Player player;
    
    void Start()
    {
        nbPlayers = gameplayManager.allPlayers.Count;
        
        NFCController.OnNewTag = OnNewTagDetected;  
        NFCController.OnTagRemoved = OnTagRemoveDetected;


        switch (nbPlayers)
        {
            case 4:
                NFCController.StartPollingAsync(antennaP1);
                NFCController.StartPollingAsync(antennaP2);
                NFCController.StartPollingAsync(antennaP3);
                NFCController.StartPollingAsync(antennaP4);
                break;
            case 3:
                NFCController.StartPollingAsync(antennaP1);
                NFCController.StartPollingAsync(antennaP2);
                NFCController.StartPollingAsync(antennaP3);
                break;
            default:
                Debug.Log("Error nb player");
                break;
        }
    }

    private void FixedUpdate()
    {
        if (canNFC)
        {
            //Colorize();
        }
        else
        {
            //ShutLights();
        }
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
        text.text = ComparePlayer(_device).player + " " + _tag.Data + " " + _tag.Type.ToString() + " added on " + _device.ToString();
    }
    
    private void OnTagRemoveDetected(NFC_DEVICE_ID _device, NFCTag _tag)  
    {
        text.text = _tag.Data + " " + _tag.Type.ToString() + " removed from " + _device.ToString();
    }
    
    private Player ComparePlayer(NFC_DEVICE_ID device)
    {
        switch (nbPlayers)
        {
            case 4:
                foreach (var deviceId in antennaP4)
                {
                    if (deviceId == device)
                        player = gameplayManager.allPlayers[0];
                }
                
                foreach (var deviceId in antennaP3)
                {
                    if (deviceId == device)
                        player = gameplayManager.allPlayers[1];
                }
                
                foreach (var deviceId in antennaP2)
                {
                    if (deviceId == device)
                        player = gameplayManager.allPlayers[2];
                }
                foreach (var deviceId in antennaP1)
                {
                    if (deviceId == device)
                        player = gameplayManager.allPlayers[3];
                }
                break;
            
            case 3:
                foreach (var deviceId in antennaP3)
                {
                    if (deviceId == device)
                        player = gameplayManager.allPlayers[0];
                }
                
                foreach (var deviceId in antennaP2)
                {
                    if (deviceId == device)
                        player = gameplayManager.allPlayers[1];
                }
                
                foreach (var deviceId in antennaP1)
                {
                    if (deviceId == device)
                        player = gameplayManager.allPlayers[2];
                }
                break;
            
            default:
                Debug.Log("HELL NO ANTENNA");
                break;
        }
        
        return player;
    }
}