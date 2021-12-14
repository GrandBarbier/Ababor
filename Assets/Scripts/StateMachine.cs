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

        
    }

    public void ChangeState(State newState)
    {
        _currentState = newState;
    }
}
