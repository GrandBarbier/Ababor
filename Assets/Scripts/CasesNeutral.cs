using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using UnityEngine;
using UnityEngine.SceneManagement;
using Random = UnityEngine.Random;

public class CasesNeutral : MonoBehaviour
{
    public bool isInRange;

    public Animator kraken;
    
    public List<CasesNeutral> nextCases;
    
    public Material baseMat;
    public Material rangedMat;
    public Material baseSecondMat;
    public Material[] allMat;
    public List<Marauder> allSteps = new List<Marauder>();
    
    [SerializeField] private GameplayManager _gameplayManager;
    [SerializeField] private EventManager _eventManager;

    public GameObject showObject;
    public GameObject menuEnd;
    public List<GameObject> playerSpot;
    
    public Renderer renderer;

    public Shop shop;
    
    public int index;
    
    public string nameFunction;
    
    public Player activPlayer;
    
    public Event eventS;
    
    public Objectif objectif;

    public CasesNeutral lastCase;

    public AudioSource soundCase;

    public AudioClip originalSound;
    public AudioClip cantEventSound;

    public bool canEvent;
    // Start is called before the first frame update
    void Awake()
    {
        _eventManager = FindObjectOfType<EventManager>();
        _gameplayManager = FindObjectOfType<GameplayManager>();
        objectif = FindObjectOfType<Objectif>();
        eventS = gameObject.GetComponent<Event>();
        shop = FindObjectOfType<Shop>();
        allMat = renderer.materials;
        ResetColor();
        
        AddDescendantsWithTag(transform, "Steps", allSteps);
    }


    private void Start()
    {
        foreach (var marauder in allSteps)
        {
            marauder.StopSteps();
        }
        canEvent = true;
    }

    // Update is called once per frame
    void Update()
    {
        if (canEvent == false)
        {
            soundCase.clip = cantEventSound;
        }
    }

    public void Outline(List<CasesNeutral> list, float remain, PlayerMovement player)
    {
        if (remain > 0)
        {
            foreach (CasesNeutral obj in nextCases )
            {
                obj.Outline(obj.nextCases, remain-1,player);
                obj.allMat[0] = rangedMat;
                obj.renderer.materials = obj.allMat;
                obj.isInRange = true;
            }
            

            for (int i = 0; i < nextCases.Count; i++)
            {
              player.allNextCases.Add(nextCases[i]);
            }

            foreach (var marauder in allSteps)
            {
                marauder.StartSteps();
            }
            
            for (int i = 0; i < player.actualMove- player.actualMove; i++)
            {
                foreach (var marauder in nextCases[i].allSteps)
                {
                    marauder.StartSteps();
                }
            }
        }
    }

    public void ResetColor()
    {
        allMat[0] = baseMat;
        allMat[1] = baseSecondMat;
        renderer.materials = allMat;
        isInRange = false;
        showObject.SetActive(false);
        foreach (var marauder in allSteps)
        {
            marauder.StopSteps();
        }
    }

    public void ActualCaseFunction()
    {
        Invoke(nameFunction,0);
        for (int i = 0; i < _eventManager.hiddenCases.Count; i++)
        {
            if (_eventManager.hiddenCases[i].gameObject == this.gameObject)
            {
                _eventManager.UnhideCase(_eventManager.hiddenCases[i]);
                _eventManager.hiddenCases.RemoveAt(i);
            }
        }
        _gameplayManager.OpenVerifMenu();
    }

    public void GainCase()
    {
        _gameplayManager.activPlayer.point.gold += 3;
        _gameplayManager.activPlayer.point.numberGainCase++;
        if (_gameplayManager.cardManager.numberClub == false)
        {
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.cardManager.numberClub = false;
            _gameplayManager.cardManager.ResetIndexPlayer();
            _gameplayManager.currentstate = new CardPlay();
        }
        soundCase.Play();
    }

    public void NeutralCase()
    {
        if (_gameplayManager.cardManager.numberClub == false)
        {
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.cardManager.numberClub = false;
            _gameplayManager.cardManager.ResetIndexPlayer();
            _gameplayManager.currentstate = new CardPlay();
        }
        soundCase.Play();
    }

    public void LoseCase()
    {
        _gameplayManager.activPlayer.point.gold -= 3;
        _gameplayManager.treasure += 3;
        if (_gameplayManager.activPlayer.point.gold < 0)
        {
            _gameplayManager.activPlayer.point.gold = 0;
        }
        _gameplayManager.activPlayer.point.numberLoseCase++;
        _gameplayManager.ResetLast();
        if (_gameplayManager.cardManager.numberClub == false)
        {
            _gameplayManager.ChangePlayer();
        }
        else
        {
            _gameplayManager.cardManager.numberClub = false;
            _gameplayManager.cardManager.ResetIndexPlayer();
            _gameplayManager.currentstate = new CardPlay();
        }
        soundCase.Play();
    }

    public void ShopCase()
    {
        shop.ShopOpen();
        _gameplayManager.activPlayer.point.numberShopCase++;
        _gameplayManager.ResetLast();
        soundCase.Play();
    }

    public void EndCase()
    {
        if (_gameplayManager.lastTurn == false)
        {
            _gameplayManager.turnWait = 2;
            _gameplayManager.islandIndex++;
            _gameplayManager.lastTurn = true;
            _gameplayManager.endPlayer = _gameplayManager.activPlayer;
            _gameplayManager.activPlayer.move.isEnd = true;
            if (_gameplayManager.cardManager.numberClub == false)
            {
                _gameplayManager.ChangePlayer();
            }
            else
            {
                _gameplayManager.cardManager.numberClub = false;
                _gameplayManager.cardManager.ResetIndexPlayer();
                _gameplayManager.currentstate = new CardPlay();
            }
        }
        else
        {
            _gameplayManager.NextIsland();
            _gameplayManager.ChangePlayer();
        }

        soundCase.Play();
    }

    public void LastCase()
    {
        
        objectif.lastCase = true;
        foreach (string stg in objectif.actualLateObjectif)
        {
            objectif.Invoke(stg,0);
        }
        _gameplayManager.endMenu.SetActive(true);
        _gameplayManager.endCalcul.oui = true;
    }

    public void EventCase()
    {
        if (canEvent)
        {
            soundCase.clip = originalSound;
            eventS.GetEvent();
            eventS.Invoke(eventS.eventName, 0);
            _gameplayManager.ResetLast();
            soundCase.Play();
            canEvent = false;
        }
        else
        {
            if (_gameplayManager.cardManager.numberClub == false)
            {
                _gameplayManager.ChangePlayer();
                Debug.Log("na");
            }
            else
            {
                _gameplayManager.cardManager.numberClub = false;
                _gameplayManager.cardManager.ResetIndexPlayer();
                _gameplayManager.currentstate = new CardPlay();
            }
            soundCase.Play();
        }
        _gameplayManager.activPlayer.point.numberEventCase++;
        if (kraken != null)
        {
            kraken.enabled = true;
        }
        
    }

    public void ShowIfTarget()
    {
        foreach (GameObject cases in GameObject.FindGameObjectsWithTag("CaseShow"))
        {
            cases.SetActive(false);
        }
        showObject.SetActive(true);
    }
    
    private void AddDescendantsWithTag(Transform parent, string tag, List<Marauder> list)
    {
        foreach (Transform child in parent)
        {
            if (child.gameObject.tag == tag)
            {
                list.Add(child.gameObject.GetComponent<Marauder>());
            }
            AddDescendantsWithTag(child, tag, list);
        }
    }
}
