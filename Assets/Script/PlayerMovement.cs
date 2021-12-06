using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    private GameplayManager _gameplayManager;
    [SerializeField] List<GameObject> cases = new List<GameObject>();
    [SerializeField] List<GameObject> altCases = new List<GameObject>();

  [SerializeField] private int actualCase;

  public int moveValue = 5;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>(); // Find gamemanager
        cases = _gameplayManager.allCases; // assign the cases
        altCases = _gameplayManager.allAltCases; // assign the alternative cases
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetButtonDown("Fire1"))
        {
            PlayerShowMove(); 
        }
    }

    public void PlayerShowMove()
    {
        bool startAlt = false;
        int valueAlt = 0;
        for (int i = 0; i < moveValue; i++)
        {
          //  Debug.Log(i);
            cases[actualCase + i + 1].GetComponent<Renderer>().material.color = Color.blue;
            if (cases[i].layer == 6)
            {
                valueAlt = i;
                startAlt = true;
            }

            if (valueAlt >5)
            {
                valueAlt -= 5;
            }

            if (startAlt)
            {
                for (int j = 0; j < moveValue - valueAlt; j++)
                {
                    altCases[j].GetComponent<Renderer>().material.color = Color.blue;
                }
            }
        }
    }
}
