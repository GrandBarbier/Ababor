using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class EndCalcul : MonoBehaviour
{
    public List<TMP_Text> textPoint;

    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void PointCalcul(PlayerPoint point,int number)
    {
        int allPoint = point.gold + point.point;
        textPoint[number].text = allPoint.ToString();
    }
}
