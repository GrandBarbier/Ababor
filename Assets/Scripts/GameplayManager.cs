using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class GameplayManager : MonoBehaviour
{
    public List<GameObject> players = new List<GameObject>();
    public List<GameObject> island = new List<GameObject>();
    public GameObject verifMenu,verifMenu2,endMenu,description,objectifMenu,changeTurnBox,changeOrderBox,menuSetting,menuCardExpliquation;
    public List<GameObject> menuTrade;
    
    public List<Button> buttonTrade;
    public Queue<Button> buttonQueue;
    
    public List<CasesNeutral> allCases = new List<CasesNeutral>();

    public int playerIndex, treasure, turnWait, islandIndex, goldTrade, playerInTurn;

    public bool lastTurn,uiTurned,objectifOpen, menuOpen;
    
    public State currentstate;
    
    public Objectif objectif;
    
    public TMP_Text endText,showPlayerEnd, showExchange;
    public List<TMP_Text> textGold;
    
    public Queue<Player> playerQueue = new Queue<Player>();
    public List<Player> allPlayers = new List<Player>();
    public Player endPlayer;
    public Player activPlayer;

    private Queue<PlayerMovement> moveQueue = new Queue<PlayerMovement>();
    public PlayerMovement actualMove;
    public List<PlayerMovement> testmove;
    
    public Queue<PlayerPoint> pointQueue = new Queue<PlayerPoint>();
    public PlayerPoint actualPoint;
    public PlayerPoint playerGive;
    public PlayerPoint playerReceive;
    
    public CardManager cardManager;

    public EndMenu endCalcul;

    public List<AudioClip> allMusic;
    
    public AudioSource UiSound;

    public List<Marauder> allSteps;

    public HardwareManager hardManager;
    
  [SerializeField]  private AudioSource musicAudioSource;
  [SerializeField]  private AudioSource sfxSource;

  [SerializeField] private AudioMixer mixer;

  [SerializeField]  private Slider musicSlider;
  [SerializeField]  private Slider sfxSlider;

  private const string MIXER_MUSIC = "MusicVolume";
  private const string MIXER_SFX = "SfxVolume";
  private const string MIXER_UI = "UiVolume";
  
  
  public GameObject tuto;
  public GameObject summary;
  private GameObject temp;
  public GameObject pdfTutorial;
  public GameObject loadingScreen;
  public GameObject loadingSprite;
  
    void Awake()
    {
        GetCases();
        for (int i = 0; i < players.Count; i++)
        {
            Player pl = new Player();
            pl.player = players[i]; 
            pl.move = players[i].GetComponent<PlayerMovement>();
            pl.point = players[i].GetComponent<PlayerPoint>();
            allPlayers.Add(pl);
        }
        currentstate = new CardPlay();
        
        musicSlider.onValueChanged.AddListener(SetMusicVolume);
        sfxSlider.onValueChanged.AddListener(SetSfxVolume);
       SetMusicVolume(1);
       SetSfxVolume(1);
    }

    void SetVolumes()
    {
        musicSlider.value = PlayerPrefs.GetFloat(MIXER_MUSIC);
        sfxSlider.value = PlayerPrefs.GetFloat(MIXER_SFX);
    }
    
    void SetMusicVolume(float value)
    {
        mixer.SetFloat(MIXER_MUSIC, Mathf.Log10(value) * 20);
        PlayerPrefs.SetFloat(MIXER_MUSIC, value);
        PlayerPrefs.Save();
    }
    void SetSfxVolume(float value)
    {
        mixer.SetFloat(MIXER_SFX, Mathf.Log10(value) * 20);
        mixer.SetFloat(MIXER_UI, Mathf.Log10(value) * 20);
        PlayerPrefs.SetFloat(MIXER_SFX, value);
        PlayerPrefs.Save();
    }

    void Start()
    {
        Application.targetFrameRate = 20;
        activPlayer = allPlayers[0];
        foreach (Player player in allPlayers)
        {
            playerQueue.Enqueue(player);
            moveQueue.Enqueue(player.move);
            pointQueue.Enqueue(player.point);
        }

        testmove = moveQueue.ToList();
        currentstate.DoState(allPlayers[playerIndex].move, this);
        ShowActualPlayer();
        //son???

        musicAudioSource.clip = allMusic[0];
        musicAudioSource.Play();

        foreach (GameObject obj in GameObject.FindGameObjectsWithTag("Steps"))
        {
            allSteps.Add(obj.GetComponent<Marauder>());
        }
    }

    // Update is called once per frame
    void Update()
    {
        activPlayer = allPlayers[playerIndex];
        actualMove = allPlayers[playerIndex].move;
        actualPoint = allPlayers[playerIndex].point;
        
        if (playerIndex < 0)
        {
            playerIndex = 0;
        }

        if (lastTurn)
        {
            if (turnWait == 0)
            { 
                NextIsland();    
            }
        }

        if (Input.touchCount>0)
        {
            foreach (GameObject obj in GameObject.FindGameObjectsWithTag("Feedback"))
            {
                obj.SetActive(false);
            }
        }
    }

    public int SortByName(CasesNeutral object1, CasesNeutral object2) // function to sort cases
    {
       return  object1.index.CompareTo(object2.index);
    }

    public void ButtonStart()
    {
        currentstate.DoState(allPlayers[playerIndex].move, this);
    }
    
    public void ChangePlayer()
    {
      
        currentstate = new EndTurn(); 
        currentstate.DoState(allPlayers[playerIndex].move, this);
        playerIndex++;
        
        if (playerIndex >= allPlayers.Count)
        {
            playerIndex = 0;
        }
        foreach (string stg in objectif.actualObjectif)
        {
            objectif.Invoke(stg,0);
        }
        if (actualMove.isLast)
        {
            ChangePlayerOrder();
            StartCoroutine("ChangeOrderBox");
        }
        else if (endPlayer != null)
        {
            StartCoroutine("ShowPlayerEnd");
        }
        else
        {
            StartCoroutine("ChangeTurnBox");
        }
        ButtonStart();
        ShowActualPlayer();
        cardManager.hardManager.Colorize();
    }

    public void ButtonYes()
    {
        actualMove.end = true;
        cardManager.verif = false;
    }
    
    public void FindBestPlayer()
    {
        int best = 0;
        string bestPlayer;
        foreach (Player player in allPlayers)
        {
            if (player.point.point >= best)
            {
                best = player.point.point;
                bestPlayer = player.point.player.name;
                endText.text = "Gagnant : " + bestPlayer + " Point : " + best;
            }
        }
    }

    public void ChangePlayerOrder()
    {
        foreach (CasesNeutral cases in allCases)//enlever
        {
            cases.canEvent = true;
        }
        Debug.Log("changement ordre joueur");
        actualMove.isLast = false;
        allPlayers[0].move.isLast = true;
        moveQueue.Enqueue(allPlayers[0].move);
        moveQueue.Dequeue();
        
        playerQueue.Enqueue(allPlayers[0]);
        playerQueue.Dequeue();
        allPlayers = playerQueue.ToList();

        testmove = moveQueue.ToList();
        buttonTrade.Add(buttonTrade[0]);
        buttonTrade.RemoveAt(0);
        turnWait--;
        playerIndex = 0;
        for (int i = 0; i < allPlayers.Count; i++)
        {
            allPlayers[i].move.index = i;
        }

        for (int i = 0; i < cardManager.playerPlayed.Count; i++)
        {
            cardManager.playerPlayed[i] = false;
        }
        ShowActualPlayer();
        cardManager.hardManager.Colorize();
    }

    public void ResetMove()
    {
        foreach (Player  player in allPlayers )
        {
            player.move.enabled = false;
        }
    }

    public void ResetSteps()
    {
        foreach (Marauder step in allSteps)
        {
            step.StopSteps();
        }
    }

    public void OpenVerifMenu()
    {
        verifMenu.SetActive(true);
        verifMenu2.SetActive(true);
    }

    public void ButtonVerifMenuMove()
    {
        currentstate = new Moving();
        currentstate.DoState(actualMove, this);
        verifMenu.SetActive(false);
        verifMenu2.SetActive(false);
        description.gameObject.SetActive(false);
        ResetLast();
    }

    public void ButtonEnd()
    {
        currentstate = new EndTurn();
        currentstate.DoState(actualMove,this);
        verifMenu.SetActive(false);
        verifMenu2.SetActive(false);
    }

    public void ResetLast()
    {
        allPlayers[allPlayers.Count -1].move.isLast = true;
    }

    public void GetCases()
    {
        foreach (GameObject obj in GameObject.FindGameObjectsWithTag("Case").ToList())
        {
            allCases.Add(obj.GetComponent<CasesNeutral>());
            allCases.Reverse();
            allCases.Sort(SortByName);
        }
    }

    public void NextIsland()
    {
        foreach (Player player in allPlayers)
        {
            player.move.caseNext[0] = allCases[0];
            player.player.transform.position = player.move.caseNext[0].transform.position;
            player.move.isEnd = false;
        }
        
        island[islandIndex].SetActive(true);
        island[islandIndex-1].SetActive(false);
        allCases.Clear();
        GetCases();
        foreach (Player player in allPlayers)
        {
            player.move.caseNext[0] = allCases[0];
            player.player.transform.position = player.move.caseNext[0].playerSpot[player.move.index].transform.position;
        }
        lastTurn = false;
        turnWait = -1;
        musicAudioSource.clip = allMusic[islandIndex];
        musicAudioSource.Play();
        allSteps.Clear();
        
        foreach (GameObject obj in GameObject.FindGameObjectsWithTag("Steps"))
        {
            allSteps.Add(obj.GetComponent<Marauder>());
        }
    }

    public IEnumerator OpenObjectif()
    {
        objectifMenu.SetActive(true);
        yield return new WaitForSeconds(.2f);
        objectifOpen = true;
    }
    
    public void CloseObjectif()
    {
        objectifMenu.SetActive(false);
    }

    public void GiveGold()
    {
        playerGive.gold -= goldTrade;
        playerReceive.gold += goldTrade;
        foreach (GameObject menu in menuTrade)
        {
            menu.SetActive(false);
            menuOpen = false;
        }
       
        StartCoroutine("ShowGoldExchange");
        goldTrade = 0;
    }

    public void GoldChange(int value)
    {
        goldTrade += value;
        if (goldTrade <=0)
        {
            goldTrade = 0;
        }

        if (goldTrade >= playerGive.gold)
        {
            goldTrade = playerGive.gold;
        }
        textGold[playerGive.index].text = goldTrade.ToString();
    }

    public void OpenMenuTrade(PlayerPoint point)
    {
        if (menuOpen == false)
        {
            menuOpen = true;
        }
        else
        {
             foreach (GameObject menu in menuTrade)
             {
                 menu.SetActive(false);
                 menuOpen = false;
             }
        }
        
        foreach (Button button in buttonTrade)
        {
            if (EventSystem.current.currentSelectedGameObject == button.gameObject)
            {
                menuTrade[point.index].transform.rotation = button.gameObject.transform.rotation;
            }
        }
      //  bool open = menuTrade[point.index].activeSelf;
        textGold[point.index].text = "0";
        goldTrade = 0;
        menuTrade[point.index].SetActive(menuOpen);
        playerGive = point;
    }

    public void TargetTrade(PlayerPoint point)
    {
        playerReceive = point;
    }

    public void TurnUi()
    {
        if (uiTurned == false)
        {
            for (int i = 0; i < buttonTrade.Count; i++)
            {
                switch (i)
                {
                    case 3:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0,0,140);
                        break;
                    case 2:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, -140);
                        break;
                    case 1:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, -45);
                        break;
                    case 0:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, 45);
                        break;
                }
            }
            uiTurned = true;
        }
        else
        {
            for (int i = 0; i < buttonTrade.Count; i++)
            {
                switch (i)
                {
                    case 3:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0,0,180);
                        break;
                    case 2:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, 180);
                        break;
                    case 1:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, 0);
                        break;
                    case 0:
                        buttonTrade[i].gameObject.transform.rotation = Quaternion.Euler(0, 0, 0);
                        break;
                }
            }
            uiTurned = false; 
        }
    }

    public void ChangeIsleButton()
    {
        islandIndex++;
        island[islandIndex].SetActive(true);
        island[islandIndex-1].SetActive(false);
        GetCases();
        foreach (Player player in allPlayers)
        {
            player.move.caseNext[0] = allCases[0];
        }
    }

    public void ShowActualPlayer()
    {
        playerInTurn = allPlayers[playerIndex].move.index;
        foreach (Button button in buttonTrade)
        {
            if (buttonTrade.IndexOf(button) == playerInTurn)
            {
                button.image.color = Color.white;
            }
            else
            {
                button.image.color = Color.gray;
            }
        }
    }

    public void CheckLast()
    {
        Debug.Log(playerQueue.Peek().move);
        playerQueue.Dequeue();
    }

    public void ResetAllPlayerButton()
    {
        foreach (Button button in buttonTrade)
        {
            button.image.color = Color.white;
        }
    }

    public void ButtonObjectif(int rotation)
    {
        StartCoroutine(OpenObjectif());
        objectifMenu.transform.rotation = new Quaternion(0, 0, rotation, 0);
    }

    public void ButtonSetting(int rotation)
    {
      menuSetting.SetActive(true);
      menuSetting.transform.rotation = new Quaternion(0, 0, rotation, 0);
    }

    public void CloseSetting()
    {
        menuSetting.SetActive(false);
    }

    public void ButtonCard(int rotation)
    {
        menuCardExpliquation.SetActive(true);
        menuCardExpliquation.transform.rotation = new  Quaternion(0,0,rotation,0) ;
    }

    public void CloseCardExpliquation()
    {
        menuCardExpliquation.SetActive(false);
    }

    public void CancelMove()
    {
        currentstate = new CardPlay();
        currentstate.DoState(actualMove, this);
        verifMenu.SetActive(true);
        verifMenu2.SetActive(true);
        description.gameObject.SetActive(false);
        actualMove.PlayerResetCase();
    }
    
    IEnumerator ChangeTurnBox()
    {
        changeTurnBox.SetActive(true);
        yield return new WaitForSeconds(5f);
        changeTurnBox.SetActive(false);
    }

    IEnumerator ChangeOrderBox()
    {
        changeOrderBox.SetActive(true);
        yield return new WaitForSeconds(5f);
        changeOrderBox.SetActive(false);
    }

    IEnumerator ShowPlayerEnd()
    {
        int text = endPlayer.move.index + 1;
        showPlayerEnd.text += text.ToString();
        showPlayerEnd.gameObject.SetActive(true);
        yield return new WaitForSeconds(5f);
        showPlayerEnd.gameObject.SetActive(false);
    }

    IEnumerator ShowGoldExchange()
    {
        int textReveive = playerReceive.index+1;
        int textGive = playerGive.index+1;
        int textGold = goldTrade;
        showExchange.text = "Le joueur " + textGive;
        showExchange.text += " donne " + textGold + " d'or au joueur " + textReveive;
        
        showExchange.gameObject.SetActive(true);
        yield return new WaitForSeconds(5f);
        showExchange.gameObject.SetActive(false);
    }
    
    public void USound(AudioClip sound)
    {
        UiSound.clip = sound;
        UiSound.Play();
        Debug.Log("sound");
    }

    public void ReturnMenu()
    {
        hardManager.ShutLights();
        StartCoroutine(LoadSceneMenu());
    }
    
    public void OpenTuto()
    {
        tuto.SetActive(true);
    }
    
    
    public void OpenTutoText(GameObject text)
    {
        temp = text;
        text.SetActive(true);
        summary.SetActive(false);
    }

    public void SummaryBackButton()
    {
        if (summary.activeInHierarchy)
        {
            pdfTutorial.SetActive(false);
        }
        else
        {
            temp.SetActive(false);
            summary.SetActive(true);
        }
    }
    
    IEnumerator LoadSceneMenu()
    {
        float rotate = 0;
        loadingScreen.SetActive(true);
        AsyncOperation operation = SceneManager.LoadSceneAsync("Main menu");
        while (!operation.isDone)
        { 
            loadingSprite.transform.Rotate(new Vector3(0,0,rotate));
            rotate = 45 * Time.deltaTime;
            yield return null;
        }
    }
}

public class Player
{
    public GameObject player;
    public PlayerMovement move;
    public PlayerPoint point;
}