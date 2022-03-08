using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Wizama.Hardware.Antenna;
using Wizama.Hardware.Light;

public class NFCConvertor : MonoBehaviour
{
    public HardwareManager hardwareManager;
    public CardManager cardManager;
    
    public void Conversion(NFCTag tag, Player player)
    {
        switch (tag.Data)
        {
             case "1G":
                 cardManager.OpenCardMenu("OneGreen", player);
                 break;
             
             case "2G":
                 cardManager.OpenCardMenu("TwoGreen", player);
                 break;
             
             case ";G":
                 cardManager.OpenCardMenu("Jack", player);
                 cardManager.CancelInvoke();
                 cardManager.waitMenu.SetActive(false);
                 break;
             
             case"<G":
                 cardManager.OpenCardMenu("QueenGreen", player);
                 break;
             
             case "=G":
                 cardManager.OpenCardMenu("KingGreen", player);
                 break;
             
             
             
             
             
             case "1B":
                 cardManager.OpenCardMenu("OneBlue", player);
                 break;
             
             case "2B":
                 cardManager.OpenCardMenu("TwoBlue", player);
                 break;
             
             case ";B":
                 cardManager.OpenCardMenu("Jack", player);
                 cardManager.CancelInvoke();
                 cardManager.waitMenu.SetActive(false);
                 break;
             
             case"<B":
                 cardManager.OpenCardMenu("QueenBlue", player);
                 break;
             
             case "=B":
                 cardManager.OpenCardMenu("KingBlue", player);
                 break;
             
             
             
             
             
             case "3R":
                 cardManager.OpenCardMenu("ThreeRed", player);
                 break;
             
             case "5R":
                 cardManager.OpenCardMenu("FiveRed", player);
                 break;
             case ";R":
                 cardManager.OpenCardMenu("Jack", player);
                 cardManager.CancelInvoke();
                 cardManager.waitMenu.SetActive(false);
                 break;
             
             case"<R":
                 cardManager.OpenCardMenu("QueenRed", player);
                 break;
             
             case "=R":
                 cardManager.OpenCardMenu("KingRed", player);
                 break;
             
             
             
             
             case "3Y":
                 cardManager.OpenCardMenu("ThreeYellow", player);
                 break;
             
             case "5Y":
                 cardManager.OpenCardMenu("FiveYellow", player);
                 break;
             case ";Y":
                 cardManager.OpenCardMenu("Jack", player);
                 cardManager.CancelInvoke();
                 cardManager.waitMenu.SetActive(false);
                 break;
             
             case "<Y":
                 cardManager.OpenCardMenu("QueenYellow", player);
                 break;
             case "=Y":
                 cardManager.OpenCardMenu("KingYellow", player);
                 break;
        }
    }
}
