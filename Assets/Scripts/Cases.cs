using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class Cases : MonoBehaviour
{
    public List<GameObject> nextCases = new List<GameObject>();

    public GameplayManager _gameplayManager;

    public int index;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        index = _gameplayManager.allCases.IndexOf(gameObject);
        FindNext();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

     public virtual void FindNext()
    {
        nextCases.Add(_gameplayManager.allCases[index+1]);
    }

    public void ChangeColor()
    {
        gameObject.GetComponent<Renderer>().material.color = Color.blue;
    }
}
