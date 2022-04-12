using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
    public GameObject settings; 
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
    public void ThreePlayerGame()
    {
        SceneManager.LoadScene("SceneThree");
    }

    public void FourPLayerGame()
    {
        SceneManager.LoadScene("Scen Expo");
    }

    public void OpenSettings()
    {
        settings.SetActive(true);
    }

    public void CloseSettings()
    {
        settings.SetActive(false);
    }
}
