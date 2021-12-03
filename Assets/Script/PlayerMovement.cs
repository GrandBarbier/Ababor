using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    private GameplayManager _gameplayManager;
    [SerializeField] List<GameObject> cases = new List<GameObject>();

  [SerializeField] private int actualCase;

  public int moveValue = 5;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        cases = _gameplayManager.allCases;     
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetButtonDown("Fire1"))
        {
           PlayerMove(); 
        }
    }

    public void PlayerMove()
    {
        for (int i = 0; i < moveValue; i++)
        {
            cases[actualCase + i + 1].GetComponent<Renderer>().material.color = Color.blue;
            
        }
    }
}
