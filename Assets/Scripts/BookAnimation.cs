using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BookAnimation : MonoBehaviour
{
    public Animator animator;


    private void Awake()
    {
        animator = GetComponent<Animator>();
    }

    void Start()
    {
        animator.SetBool("Open", false);
        animator.SetBool("Page 1", false);
        animator.SetBool("Page 2", false);
        animator.SetBool("Page 3", false);
    }

    public void AnimOpen()
    {
        animator.SetBool("Open", true);
    }
    public void AnimPageOne()
    {
        animator.SetBool("Page 1", true);
    }
    public void AnimPageTwo()
    {
        animator.SetBool("Page 2", true);
    }
    public void AnimPageThree()
    {
        animator.SetBool("Page 3", true);
    }

    public void DepopEarly()
    {
        Debug.Log("Oui bravo");
    }
    
    public void DepopMid()
    {
        Debug.Log("Oui bravo le mid");
    }
}
