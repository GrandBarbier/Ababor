using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MainMenu : MonoBehaviour
{
    public GameObject settings;
    public GameObject credit;
    public GameObject tuto;
    public GameObject summary;
    private GameObject temp;
    public GameObject pdfTutorial;

    public AudioSource sound;

    public GameObject loadingScreen;
    public GameObject loadingSprite;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public void LaunchGame(int id)
    {
        StartCoroutine(LoadScenePl(id));
    }

    public void OpenSettings()
    {
        settings.SetActive(true);
    }

    public void CloseSettings()
    {
        settings.SetActive(false);
    }

    public void OpenCredit()
    {
        credit.SetActive(true);
    }

    public void CloseCredit()
    {
        credit.SetActive(false);
    }

    public void Sound(AudioClip clip)
    {
        sound.clip = clip;
        sound.Play();
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
        pdfTutorial.GetComponentInChildren<ScrollRect>().enabled = false;

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
            pdfTutorial.GetComponentInChildren<ScrollRect>().enabled = true;
        }
    }
    
    IEnumerator LoadScenePl(int id)
    {
        float rotate = 0;
        loadingScreen.SetActive(true);
        AsyncOperation operation = SceneManager.LoadSceneAsync(id);
        while (!operation.isDone)
        { 
            loadingSprite.transform.Rotate(new Vector3(0,0,rotate));
            rotate = 45 * Time.deltaTime;
            yield return null;
        }
    }

}
