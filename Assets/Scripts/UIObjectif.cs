using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIObjectif : MonoBehaviour
{

    public List<GameObject> uiObjectif;

    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public void UiObjectiveGame(int index)
    {
        if (uiObjectif[index].activeSelf)
        {
            uiObjectif[index].SetActive(false);
        }
        else
        {
            uiObjectif[index].SetActive(true);
        }
    }

}
