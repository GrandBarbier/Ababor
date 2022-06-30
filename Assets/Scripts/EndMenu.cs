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
    public List<int> objectivesPoint;
    public List<TMP_Text> textObjPts;

    public List<Image> placementMid1 = new List<Image>(4);
    public List<Image> placementMid2 = new List<Image>(4);

    
    public List<Image> placement = new List<Image>(6);
    
    public Objectif goal;
    
    [SerializeField]private float step = 2f;
    [SerializeField]private float scaleFactor = 0.0012f;

    private float alpha = 0f;


    private bool once = true;
    public bool oui;

    public GameObject button;

    public AudioClip victorySound;

    private void Awake()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        allPlayers = _gameplayManager.allPlayers;
    }

    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < _gameplayManager.allPlayers.Count; i++) 
            textPoint[i].text = _gameplayManager.allPlayers[i].point.gold.ToString();
        
        foreach (var player in _gameplayManager.allPlayers) 
            player.point.point += player.point.gold;
     
        for (int i = 0; i < 6; i++)
        {
            textGoal[i].text = goal.actualDescription[i].Remove(goal.actualDescription[i].IndexOf("gagne"));
            
            objectivesPoint[i] = _gameplayManager.objectif.allScore[i];
            textObjPts[i].text = objectivesPoint[i].ToString() + "pts"; 
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
        else if (heads.transform.position == downGameObject.transform.position && once)
        {
            ShowObj();
            once = false;
        }
    }

    private void ShowObj()
    {
        for (int i = 0; i < 3; i++)
        {
            while (alpha < 0.9)
            {
                alpha += 0.02f;
                backgrounds[i*2].color = new Color(1,1,1,alpha);
                backgrounds[i*2+1].color = new Color(1,1,1, alpha);
                textGoal[i*2].color = new Color(1,1,1, alpha);
                textGoal[i*2+1].color = new Color(1,1,1, alpha);
                textGoal[i+6].color = new Color(1,1,1, alpha);
                textObjPts[i*2].color = new Color(1,0,0,alpha);
                textObjPts[i*2+1].color = new Color(1,0,0, alpha);
            }
            alpha = 0;
        }
        ShowFacesOnObj();
    }

    private void ShowFacesOnObj()
    {
        int indexMid1 = 0;
        int indexMid2 = 0;
        for (int i = 0; i < allPlayers[0].point.objectifVerif.Count; i++)
        {
            for (int j = 0; j < allPlayers.Count; j++)
            {
                if (allPlayers[j].point.objectifVerif[i])
                {
                    if (i == 2)
                    {
                        placementMid1[indexMid1].sprite = allPlayers[j].player.GetComponent<SpriteRenderer>().sprite;
                        placementMid1[indexMid1].gameObject.SetActive(true);
                        allPlayers[j].point.point += objectivesPoint[i];
                        textPoint[j].text = allPlayers[j].point.point.ToString();
                        indexMid1++;
                    }
                    else if (i == 3)
                    {
                        placementMid2[indexMid2].sprite = allPlayers[j].player.GetComponent<SpriteRenderer>().sprite;
                        placementMid2[indexMid2].gameObject.SetActive(true);
                        allPlayers[j].point.point += objectivesPoint[i];
                        textPoint[j].text = allPlayers[j].point.point.ToString();
                        indexMid2++;
                    }
                    else
                    {
                        placement[i].sprite = allPlayers[j].player.GetComponent<SpriteRenderer>().sprite;
                        placement[i].gameObject.SetActive(true);
                        allPlayers[j].point.point += objectivesPoint[i];
                        textPoint[j].text = allPlayers[j].point.point.ToString();
                    }
                }
            }
        }
        button.SetActive(true);
        _gameplayManager.UiSound.clip = victorySound;
        _gameplayManager.UiSound.Play();
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
