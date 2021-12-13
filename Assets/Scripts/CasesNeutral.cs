using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CasesNeutral : Cases
{
    public bool isInRanged;

    public Color baseColor;

    public Renderer renderer;
    // Start is called before the first frame update
    void Start()
    {
        _gameplayManager = FindObjectOfType<GameplayManager>();
        baseColor = renderer.material.color;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Outline(List<GameObject> list, float remain)
    {
        if (remain > 0)
        {
            foreach (GameObject obj in nextCases )
            {
                obj.GetComponent<CasesNeutral>().Outline(obj.GetComponent<CasesNeutral>().nextCases, remain-1);
                obj.GetComponent<Renderer>().material.color = Color.blue;
                obj.GetComponent<CasesNeutral>().isInRanged = true;
            }
        }
    }

    public void ResetColor()
    {
        renderer.material.color = baseColor;
        isInRanged = false;
    }
}
