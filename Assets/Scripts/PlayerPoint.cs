using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class PlayerPoint : MonoBehaviour
{
    public int gold;
    public TMP_Text text;
    public int point;

    public int numberGainCase;

    public int numberLoseCase;

    public int numberEventCase;

    public int numberShopCase;

    public int numberCase;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        text.text = gold.ToString();
    }
}
