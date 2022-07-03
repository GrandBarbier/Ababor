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
        string description = "test";
        switch (tag.Data)
        {
             case "1G":
                 description = "Avance d'une case";
                 cardManager.OpenCardMenu1Target("OneGreen", player,description, player.point.index);
                 cardManager.oneTarget = true;
                 break;
             
             case "2G":
                 description = "Avance de deux cases";
                 cardManager.OpenCardMenu1Target("TwoGreen", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
             
             case ";G":
                 description = "Annulez et copiez la dernière carte jouer";
                 if (cardManager.oneTarget && cardManager.waitMenu.activeSelf)
                 {
                      cardManager.OpenCardMenu1Target("Jack", player,description,player.point.index);
                 }
                 else if (cardManager.waitMenu.activeSelf)
                 {
                     cardManager.OpenCardMenu("Jack", player,description,player.point.index);
                 }
                 cardManager.CancelInvoke();
                 cardManager.waitMenu.SetActive(false);
                 break;
             
             case"<G":
                 description = "Vous vous déplacez vers votre cible";
                 cardManager.OpenCardMenu1Target("QueenGreen", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
             
             case "=G":
                 description = "Vous échanger votre place avec un joueur";
                 cardManager.OpenCardMenu1Target("KingGreen", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
             
             
             
             
             
             case "1B":
                 description = "Reculez d'une case";
                 cardManager.OpenCardMenu1Target("OneBlue", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
             
             case "2B":
                 description = "Reculez de 2 cases";
                 cardManager.OpenCardMenu1Target("TwoBlue", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
             
             case ";B":
                 description = "Annulez et copiez la dernière carte jouer";
                 if (cardManager.oneTarget && cardManager.waitMenu.activeSelf)
                 {
                     cardManager.OpenCardMenu1Target("Jack", player,description,player.point.index);
                 }
                 else if (cardManager.waitMenu.activeSelf)
                 {
                     cardManager.OpenCardMenu("Jack", player,description,player.point.index);
                 }
                 cardManager.CancelInvoke();
                 cardManager.waitMenu.SetActive(false);
                 break;
             
             case"<B":
                 description = "Un joueur en rejoins un autre";
                 cardManager.OpenCardMenu("QueenBlue", player,description,player.point.index);
                 cardManager.oneTarget = false;
                 break;
             
             case "=B":
                 description = "Echange la place de 2 joueurs";
                 cardManager.OpenCardMenu("KingBlue", player,description,player.point.index);
                 cardManager.oneTarget = false;
                 break;
             
             
             
             
             
             case "3R":
                 description = "Perd 3 d'or";
                 cardManager.OpenCardMenu1Target("ThreeRed", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
             
             case "5R":
                 description = "Perd 5 d'or";
                 cardManager.OpenCardMenu1Target("FiveRed", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
             case ";R":
                 description = "Annulez et copiez la dernière carte jouer";
                 if (cardManager.oneTarget && cardManager.waitMenu.activeSelf)
                 {
                     cardManager.OpenCardMenu1Target("Jack", player,description,player.point.index);
                 }
                 else if (cardManager.waitMenu.activeSelf)
                 {
                     cardManager.OpenCardMenu("Jack", player,description,player.point.index);
                 }
                 cardManager.CancelInvoke();
                 cardManager.waitMenu.SetActive(false);
                 break;
             
             case"<R":
                 description = "Un joueur donne 5 d'or a un autre joueur";
                 cardManager.OpenCardMenu("QueenRed", player,description,player.point.index);
                 cardManager.oneTarget = false;
                 break;
             
             case "=R":
                 description = "Un joueur donne 3 d'or a tout les autres joueurs";
                 cardManager.OpenCardMenu1Target("KingRed", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
             
             
             
             
             case "3Y":
                 description = "Donne 3 d'or";
                 cardManager.OpenCardMenu1Target("ThreeYellow", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
             
             case "5Y":
                 description = "Donne 5 d'or";
                 cardManager.OpenCardMenu1Target("FiveYellow", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
             case ";Y":
                 description = "Annulez et copiez la dernière carte jouer";
                 if (cardManager.oneTarget && cardManager.waitMenu.activeSelf)
                 {
                     cardManager.OpenCardMenu1Target("Jack", player,description,player.point.index);
                 }
                 else if (cardManager.waitMenu.activeSelf)
                 {
                     cardManager.OpenCardMenu("Jack", player,description,player.point.index);
                 }
                 cardManager.CancelInvoke();
                 cardManager.waitMenu.SetActive(false);
                 break;
             
             case "<Y":
                 description = "Un joueur récupère le pot commun";
                 cardManager.OpenCardMenu1Target("QueenYellow", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
             case "=Y":
                 description = "Tout les joueurs donne 5 d'or à un joueur";
                 cardManager.OpenCardMenu1Target("KingYellow", player,description,player.point.index);
                 cardManager.oneTarget = true;
                 break;
        }
    }
}
