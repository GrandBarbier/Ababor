using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;
using UnityEngine.Audio;


public class AudioManager : MonoBehaviour
{
    [SerializeField] private AudioMixer mixer;

    [SerializeField]  private Slider musicSlider;
    [SerializeField]  private Slider sfxSlider;
    
    private const string MIXER_MUSIC = "MusicVolume";
    private const string MIXER_SFX = "SfxVolume";
    private const string MIXER_UI = "UiVolume";

    // Start is called before the first frame update
    void Awake()
    {
        musicSlider.onValueChanged.AddListener(SetMusicVolume);
        sfxSlider.onValueChanged.AddListener(SetSfxVolume);
        SetVolumes();
    }

    void SetVolumes()
    {
        if (PlayerPrefs.HasKey(MIXER_MUSIC))
            musicSlider.value = PlayerPrefs.GetFloat(MIXER_MUSIC);
        if (PlayerPrefs.HasKey(MIXER_SFX))
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
}
