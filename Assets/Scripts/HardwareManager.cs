using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using TMPro;
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

    public NFC_DEVICE_ID[] allAntennas3P;
    public NFC_DEVICE_ID[] allAntennas4P;
    
    public GameplayManager gameplayManager;
    
    private State cardPlay;

    public NFCConvertor nfcConvertor;
    
    [SerializeField] 
    private bool canNFC;

    public int nbPlayers;
    
    public Text text;
    
    private Player player;
    public List<Player> allPlayer;

    public GameObject descriptionEvent;
    
    public CardManager cardManager;

    private string card;
    
    void Start()
    {
        nbPlayers = gameplayManager.allPlayers.Count;
        
        NFCController.OnNewTag = OnNewTagDetected;  
        NFCController.OnTagRemoved = OnTagRemoveDetected;

        allPlayer = gameplayManager.allPlayers;
        
        switch (nbPlayers)
        {
            case 4:
                NFCController.StartPollingAsync(allAntennas4P);
                break;
            case 3:
                NFCController.StartPollingAsync(allAntennas3P);
                break;
            default:
                Debug.Log("Error nb player");
                break;
        }
    }

    private void FixedUpdate()
    {
        if (gameplayManager.currentstate.ToString() == "CardPlay")
        {
            canNFC = true;
            Colorize();
        }
        else
        {
            canNFC = false;
            ShutLights();
        }
    }

    void OnDisable()  
    {
        NFCController.StopPolling();
    }

    private void OnApplicationQuit()
    {
        ShutLights();
    }

    public void Colorize()
    {
        switch (nbPlayers)
        {
            case 4:
                LightController.Colorize(lightsP1, LIGHT_COLOR.COLOR_RED, true);
                LightController.Colorize(lightsP2, LIGHT_COLOR.COLOR_BLUE, true);
                LightController.Colorize(lightsP3, LIGHT_COLOR.COLOR_YELLOW, true);
                LightController.Colorize(lightsP4, LIGHT_COLOR.COLOR_GREEN, true);
                break;
            
            case 3:
                LightController.Colorize(lightsP1, LIGHT_COLOR.COLOR_RED, true);
                LightController.Colorize(lightsP2, LIGHT_COLOR.COLOR_BLUE, true);
                LightController.Colorize(lightsP3, LIGHT_COLOR.COLOR_YELLOW, true);
                break;
        }
    }
    
    public void ShutLights()
    {
        LightController.ShutdownAllLights();
    }

    private void OnNewTagDetected(NFC_DEVICE_ID _device, NFCTag _tag)
    {
        if (cardManager.menu.activeSelf == false && cardManager.targetMenu.activeSelf == false && cardManager.numberClub == false)
        {
            text.text = ComparePlayer(_device).player + " " + _tag.Data + " " + _tag.Type.ToString() + " added on " +
                        _device.ToString();
            descriptionEvent.SetActive(false);
            card = _tag.Data;
            if (canNFC)
                nfcConvertor.Conversion(_tag, ComparePlayer(_device));
            Debug.Log("detect");
        }
    }

    private void OnTagRemoveDetected(NFC_DEVICE_ID _device, NFCTag _tag)  
    {
        //text.text = _tag.Data + " " + _tag.Type.ToString() + " removed from " + _device.ToString();
        if (nfcConvertor.cardManager.functionName != "Jack" && nfcConvertor.cardManager.numberClub == false && card == _tag.Data)
        {
            cardManager.CloseMenu();
            cardManager.CloseMenu1Target();   
        }
    }
    
    private Player ComparePlayer(NFC_DEVICE_ID device)
    {
        switch (nbPlayers)
        {
            case 4:
                foreach (var deviceId in antennaP4)
                {
                    if (deviceId == device)
                        player = allPlayer[3];
                }
                
                foreach (var deviceId in antennaP3)
                {
                    if (deviceId == device)
                        player = allPlayer[2];
                }
                
                foreach (var deviceId in antennaP2)
                {
                    if (deviceId == device)
                        player = allPlayer[1];
                }
                foreach (var deviceId in antennaP1)
                {
                    if (deviceId == device)
                        player = allPlayer[0];
                }
                break;
            
            case 3:
                foreach (var deviceId in antennaP3)
                {
                    if (deviceId == device)
                        player = allPlayer[2];
                }
                
                foreach (var deviceId in antennaP2)
                {
                    if (deviceId == device)
                        player = allPlayer[1];
                }
                
                foreach (var deviceId in antennaP1)
                {
                    if (deviceId == device)
                        player = allPlayer[0];
                }
                break;
            
            default:
                Debug.Log("HELL NO ANTENNA");
                break;
        }
        
        return player;
    }
}