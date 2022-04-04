using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class EndMenu : MonoBehaviour
{
    public List<TMP_Text> textPoint;
    public GameObject heads;
    public GameObject downGameObject;
    public GameObject objectives;

    public float step;
    public float scaleFactor;

    public bool oui;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (oui && heads.transform.position != downGameObject.transform.position)
        {
            MoveDown();
            ScaleDown();
        }
        Tempo();
        if (heads.transform.position == downGameObject.transform.position)
        {
            objectives.SetActive(true);
        }
    }

    public void Tempo()
    {
        
    }
    public void MoveDown()
    {
        heads.transform.position = Vector3.MoveTowards(heads.transform.position, downGameObject.transform.position, step);
    }

    public void ScaleDown()
    {
        heads.transform.localScale -= new Vector3(scaleFactor, scaleFactor, 0);
    }

    public void PointCalcul(PlayerPoint point,int number)
    {
        int allPoint = point.gold + point.point;
        textPoint[number].text = allPoint.ToString();
    }
}
