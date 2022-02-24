using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class PlayerPoint : MonoBehaviour
{
    public TMP_Text text;

    public int gold;
    public int point;
    public int numberGainCase;
    public int numberNeutralCase;
    public int numberLoseCase;
    public int numberEventCase;
    public int numberShopCase;
    public int numberCase;
   
    public GameObject player;
    
    public List<bool> objectifVerif;
    public bool isEvent;
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (gold < 0)
        {
            gold = 0;
        }
        text.text = gold.ToString();
        
        
    }
    
    
}
