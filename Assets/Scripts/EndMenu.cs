using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class EndMenu : MonoBehaviour
{
    public List<Player> allPlayers;

    private GameplayManager _gameplayManager;
    
    public List<TMP_Text> textPoint;
    public GameObject heads;
    public GameObject downGameObject;
    public List<Image> backgrounds;
    public List<TMP_Text> textGoal;

    public List<SpriteRenderer> placement = new List<SpriteRenderer>(6);
    
    public Objectif goal;
    
    public float step;
    public float scaleFactor;

    private float alpha1 = 0f;
    private float alpha2 = 0f;
    private float alpha3 = 0f;
    private float alphaTxt = 0f;


    private bool once = true;
    public bool oui;

    private void Awake()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        allPlayers = _gameplayManager.allPlayers;
    }

    // Start is called before the first frame update
    void Start()
    {
        if (textPoint[0].text != _gameplayManager.allPlayers[0].point.ToString())
        {
            textPoint[0].text = _gameplayManager.allPlayers[0].point.gold.ToString();
            textPoint[1].text = _gameplayManager.allPlayers[1].point.gold.ToString();
            textPoint[2].text = _gameplayManager.allPlayers[2].point.gold.ToString();
            textPoint[3].text = _gameplayManager.allPlayers[3].point.gold.ToString();
        }
        if (textGoal[0].text != goal.descriptionsEarly[0])
        {
            textGoal[0].text = goal.descriptionsEarly[0];
            textGoal[1].text = goal.descriptionsEarly[1];
            textGoal[2].text = goal.descriptionMid[0];
            textGoal[3].text = goal.descriptionMid[1];
            textGoal[4].text = goal.descriptionLate[0];
            textGoal[5].text = goal.descriptionLate[1];
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
        if (heads.transform.position == downGameObject.transform.position && alphaTxt < 1)
            ShowObj();
        if (once)
        {
            ShowFacesOnObj();
            AddToScore();
            once = false;
        }
    }

    private void ShowObj()
    {
        if (alpha1 < 0.9)
        {
            alpha1 += 0.02f;
            backgrounds[0].color = new Color(1, 1, 1, alpha1);
            backgrounds[1].color = new Color(1, 1, 1, alpha1);
            textGoal[0].color = new Color(1, 1, 1, alpha1);
            textGoal[1].color = new Color(1, 1, 1, alpha1);

        }
        else if (alpha2 < 0.9)
        {
            alpha2 += 0.02f;
            backgrounds[2].color = new Color(1, 1, 1, alpha2);
            backgrounds[3].color = new Color(1, 1, 1, alpha2);
            textGoal[2].color = new Color(1, 1, 1, alpha2);
            textGoal[3].color = new Color(1, 1, 1, alpha2);

        }
        else if (alpha3 < 0.9)
        {
            alpha3 += 0.02f;
            backgrounds[4].color = new Color(1, 1, 1, alpha3);
            backgrounds[5].color = new Color(1, 1, 1, alpha3);
            textGoal[4].color = new Color(1, 1, 1, alpha3);
            textGoal[5].color = new Color(1, 1, 1, alpha3);
        }
        else if (alphaTxt < 1)
        {
            alphaTxt += 0.01f;
            textGoal[6].color = new Color(textGoal[6].color.r, textGoal[6].color.g, textGoal[6].color.b, alpha3);
            textGoal[7].color = new Color(textGoal[7].color.r, textGoal[7].color.g, textGoal[7].color.b, alpha3);
            textGoal[8].color = new Color(textGoal[8].color.r, textGoal[8].color.g, textGoal[8].color.b, alpha3);

        }
    }

    private void ShowFacesOnObj()
    {
        Debug.LogError("ouiiiiiiiiiiiii");
        for (int i = 0; i < allPlayers.Count; i++)
        {
            for (int j = 0; j < allPlayers[i].point.objectifVerif.Count; j++)
            {
                if (allPlayers[i].point.objectifVerif[j])
                {
                    placement[j] = allPlayers[i].player.GetComponent<SpriteRenderer>();
                    placement[j].gameObject.SetActive(true);
                }
            }
        }
    }

    public void AddToScore()
    {
        
    }

    private void MoveDown()
    {
        heads.transform.position = Vector3.MoveTowards(heads.transform.position, downGameObject.transform.position, step);
    }

    private void ScaleDown()
    {
        heads.transform.localScale -= new Vector3(scaleFactor, scaleFactor, 0);
    }

    public void PointCalcul(PlayerPoint point,int number)
    {
        int allPoint = point.gold + point.point;
        textPoint[number].text = allPoint.ToString();
    }
}
