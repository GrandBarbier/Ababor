using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class GameplayManager : MonoBehaviour
{
    public List<GameObject> allCases = new List<GameObject>();
    public List<GameObject> allAltCases = new List<GameObject>();
    // Start is called before the first frame update
    void Awake()
    {
        allCases = GameObject.FindGameObjectsWithTag("Case").ToList(); // Add all case in a list
        allAltCases = GameObject.FindGameObjectsWithTag("CaseAlt").ToList(); // Add all alternative case in a list
        allCases.Sort(SortByName); //Sort cases by name
        allAltCases.Sort(SortByName); //Sort cases by name
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
    
    private int SortByName(GameObject object1, GameObject object2) // function to sort cases
    {
       return  object1.name.CompareTo(object2.name);
    }
}
