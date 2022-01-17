using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Event : MonoBehaviour
{
    public List<PlayerMovement> allMove;
    public GameplayManager gameplayManager;
    public List<PlayerPoint> allPoint;
    public string eventName;
    // Start is called before the first frame update
    void Start()
    {
        allMove = gameplayManager.allMove;
        allPoint = gameplayManager.allPoint;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void EventLessMove()
    {
        Debug.Log("d");
        foreach (PlayerMovement move in allMove)
        {
            Debug.Log("z");
            move.actualMove -= 3;
            move.isEvent = true;
        }
        gameplayManager.ChangePlayer();
    }
}
