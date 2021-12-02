using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StateMachine : MonoBehaviour
{
    private State _currentState;
    // Start is called before the first frame update
    void Start()
    {
        _currentState = new Acting();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Jump"))
        {
            _currentState.DoState();
           ChangeState(new Moving());
        }

        if (Input.GetButtonDown("Cancel"))
        {
            ChangeState(new CardPLay());
        }

        if (Input.GetButtonDown("Fire1"))
        {
            ChangeState(new EndTurn());
        }
        
    }

    public void ChangeState(State newState)
    {
        _currentState = newState;
    }
}
