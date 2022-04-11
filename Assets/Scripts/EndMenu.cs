using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class EndMenu : MonoBehaviour
{
    private GameplayManager _gameplayManager;
    
    public List<TMP_Text> textPoint;
    public GameObject heads;
    public GameObject downGameObject;
    public List<Image> backgrounds;
    public List<TMP_Text> textGoal;
    
    public Objectif goal;
    
    public float step;
    public float scaleFactor;

    private float alpha1;
    private float alpha2;
    private float alpha3;

    public bool oui;

    private void Awake()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
    }

    // Start is called before the first frame update
    void Start()
    {
        if (textPoint[0].text != _gameplayManager.allPlayers[0].point.ToString())
        {
            textPoint[0].text = _gameplayManager.allPlayers[0].point.point.ToString();
            textPoint[1].text = _gameplayManager.allPlayers[1].point.point.ToString();
            textPoint[2].text = _gameplayManager.allPlayers[2].point.point.ToString();
            textPoint[3].text = _gameplayManager.allPlayers[3].point.point.ToString();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (oui && heads.transform.position != downGameObject.transform.position)
        {
            MoveDown();
            ScaleDown();
        }
        ShowObj();
        
    }
    
    public void ShowObj()
    {
        if (textGoal[0].text != goal.descriptionsEarly[0])
        {
            textGoal[0].text = goal.descriptionsEarly[0];
            textGoal[1].text = goal.descriptionsEarly[1];
            textGoal[2].text = goal.descriptionMid[0];
            textGoal[3].text = goal.descriptionMid[1];
            textGoal[4].text = goal.descriptionLate[0];
            textGoal[5].text = goal.descriptionLate[1];
        }
        
        if (alpha1 < 0.9 && heads.transform.position == downGameObject.transform.position)
        {
            alpha1 += 0.02f;
            backgrounds[0].color = new Color(1, 1, 1, alpha1);
            backgrounds[1].color = new Color(1, 1, 1, alpha1);
            textGoal[0].color = new Color(1, 1, 1, alpha1);
            textGoal[1].color = new Color(1, 1, 1, alpha1);

        }
        else if (alpha2 < 0.9 && heads.transform.position == downGameObject.transform.position)
        {
            alpha2 += 0.02f;
            backgrounds[2].color = new Color(1, 1, 1, alpha2);
            backgrounds[3].color = new Color(1, 1, 1, alpha2);
            textGoal[2].color = new Color(1, 1, 1, alpha2);
            textGoal[3].color = new Color(1, 1, 1, alpha2);

        }
        else if (alpha3 < 0.9 && heads.transform.position == downGameObject.transform.position)
        {
            alpha3 += 0.02f;
            backgrounds[4].color = new Color(1, 1, 1, alpha3);
            backgrounds[5].color = new Color(1, 1, 1, alpha3);
            textGoal[4].color = new Color(1, 1, 1, alpha3);
            textGoal[5].color = new Color(1, 1, 1, alpha3);
        }
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
