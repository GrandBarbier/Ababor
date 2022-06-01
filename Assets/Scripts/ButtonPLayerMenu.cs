using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ButtonPLayerMenu : MonoBehaviour
{
    public Sprite originalSprite;

    public Sprite clickedSprite;

    public Image imageButton;

    public List<Image> card1Target;

    public List<ButtonPLayerMenu> button1Target;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void ClickedCard1()
    {
        if(imageButton.sprite == originalSprite)
        {
            imageButton.sprite = clickedSprite;
            ResetOtherCard1();
        }
        else
        {
            imageButton.sprite = originalSprite;
            ResetOtherCard1();
        }
        
    }

    public void ResetOtherCard1()
    {
        for (int i = 0; i < card1Target.Count; i++)
        {
            if (card1Target[i] != imageButton)
            {
                card1Target[i].sprite = button1Target[i].originalSprite;
            }
        }
    }
}
