using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class GameplayManager : MonoBehaviour
{
    public List<GameObject> allPart = new List<GameObject>();
    public List<GameObject> allCases = new List<GameObject>();

    public int numberCase;
  //  public List<GameObject> allAltCases = new List<GameObject>();
    // Start is called before the first frame update
    void Awake()
    {
//        allPart = GameObject.FindGameObjectsWithTag("CasePart").ToList(); // Add all case in a list
      //  allAltCases = GameObject.FindGameObjectsWithTag("CaseAlt").ToList(); // Add all alternative case in a list
        allCases = GameObject.FindGameObjectsWithTag("Case").ToList();
        allCases.Reverse();
        numberCase = allCases.Count;
        allCases.Sort(SortByName);
        //    allAltCases.Sort(SortByName); //Sort cases by name

    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
    
    private int SortByName(GameObject object1, GameObject object2) // function to sort cases
    {
       return  object1.GetComponent<CasesNeutral>().index.CompareTo(object2.GetComponent<CasesNeutral>().index);
    }
}
