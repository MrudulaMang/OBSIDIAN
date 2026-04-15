WHAT ARE the others things that may break at production level

Good question. This is exactly how you start thinking like an SRE instead of a “Docker user.”

Let me be very clear:

> Production doesn’t break in obvious ways.  
> It breaks in **weird, partial, slow, and misleading ways.**

---

## 🔥 1. Dependency Failures (you already started)

![https://images.openai.com/static-rsc-4/rEAMK8K8vxsEGAQf4xr6ev9rhoGrWE1MPEoN2yksWNa8m9g_93OARYTJuy78CG8VgZGe7GbOijwchgr2bwHAPBRZLUAELiaU1237qFeFAroK1BLl2ySfRzk9Bot6pjHbVxyn3g5TRHtuJ5plov9QPbdr5gh7GKAmAzHQM-VYgENLeo3lyGyObXPEnWRznag3?purpose=fullsize](https://images.openai.com/static-rsc-4/DtbahaCemKN4UbjgTBeWLv_5VjvT_8WJqD3-0frxtfhzB_80lSPrBrYWwfLVlNw7yIKSK-BOu9JKgw9hCYQs3_YWqYlyBR-nwuWScGaz_O9reDviqX0c-VESlc3b-6TG50W8zZjSIvGzv8-EbUyu0zU0zhXjr1KwhE6YDjMURXs?purpose=inline)

![https://images.openai.com/static-rsc-4/haG-nkz_Or0FtIakHrMS6Ssf15IlDGJKOXuL67SfIatviW9jMSuHyDh9fh3Q2lkdzYl4UgSKiS9NWXN1R-M0sqONR5JTZV1E-jjekzg31p3KlS4l3Bxy0_oF_tqOVDL7w-cOKq5m9Tm_mrLrGLxyYeVQu19xTbG7Ca59X3OVi4CciCCmxlwXdx5xPSMpWEel?purpose=fullsize](https://images.openai.com/static-rsc-4/oxbguawbBVU8fgjAD3MXRshUZnUu1djZ9OAfSrYQxEqd9clisb7l-RHyXskWTP4lO_qOcpo3F6n0Zqc-y5SKGi0muhDhSNpc0f60U4lmhHPproCMOnlGcwv6aAIQ2afM8Qxt-kDQ6bPKxcGFQQ-YqlndIZPKw4TlmQ6yNKqGEFc?purpose=inline)

![https://images.openai.com/static-rsc-4/Yy9eP-atp2a00gKykI6jkF8JOUKb0b4Epc5E_a5XBo4wh4yZos7BzhSbYOK5IT8GOH-zhBZyVgbiesuBmP0keBIqQAYlpDx1B08SMFKPpZWy9Zwl25wQ2fHwzyqjWMDSjntJzZl05VXH-gy-c6tYLy69fektcJWV9ZbY-iv5lbx_ANMn6PnpE4O1gFvlN8LG?purpose=fullsize](https://images.openai.com/static-rsc-4/DT948OOu3YlJMHeRI9a3t5WYHszItyMSuPU1JWmQZE33qtDo4ffRlOhAYRToG3kurDWBMTAUTXn8n4yyITBkA2-rCAM4Y9_9n8WvqC5jwWwRZZVBvmgh4P3W0PJMC8uS_dlJKZ7YJzS3Cs845HEAmQ_HRzRFDqJeU9Llhq-Gm-Y?purpose=inline)

6

Not just:

- Redis down ❌ (too obvious)

Also:

- Redis slow (VERY common)
- Mongo accepting connections but not responding
- DNS resolves but wrong IP

👉 Real failure:

> “Service is up, but behaving weirdly”

---

## 🔥 2. Network Issues (MOST underestimated)

![https://images.openai.com/static-rsc-4/haG-nkz_Or0FtIakHrMS6Ssf15IlDGJKOXuL67SfIatviW9jMSuHyDh9fh3Q2lkdzYl4UgSKiS9NWXN1R-M0sqONR5JTZV1E-jjekzg31p3KlS4l3Bxy0_oF_tqOVDL7w-cOKq5m9Tm_mrLrGLxyYeVQu19xTbG7Ca59X3OVi4CciCCmxlwXdx5xPSMpWEel?purpose=fullsize](https://images.openai.com/static-rsc-4/oxbguawbBVU8fgjAD3MXRshUZnUu1djZ9OAfSrYQxEqd9clisb7l-RHyXskWTP4lO_qOcpo3F6n0Zqc-y5SKGi0muhDhSNpc0f60U4lmhHPproCMOnlGcwv6aAIQ2afM8Qxt-kDQ6bPKxcGFQQ-YqlndIZPKw4TlmQ6yNKqGEFc?purpose=inline)

![https://images.openai.com/static-rsc-4/8qgJj5NZMHunl_gCTnPV-qGHj7Tgzkc7gcaZAYynUC0u2leJ17rHr7Uj6il3SzuPIgCZPIf3Kw7fW4hEwg_805fb8OtuIQdwraSwDiUPb3Ml7C9uAfbrHuFLRQ7wtwH33r-pvTU7PKaC6h_cFnKCNOuuNQiQfdnzBJxKdg87zhmdUVV-v6ngvURINA7rflD5?purpose=fullsize](https://images.openai.com/static-rsc-4/Y5p4FtEgilhxK3gwPou_I43Q4wp3iHkhGQ_E8HYPjNmoSAsoCrYIo8OaeXqGkgrfoWMkzjWiivwmagB3ge6JpYHPFmTchZPYa94WxiBMunQuR3ifvwDQpYi5rwxGw_KqaCPfUtApwIBgudK1r-oxEtq7SFMB65idIKF_PUxq8IQ?purpose=inline)

![https://images.openai.com/static-rsc-4/cpoDK5GPcUNhskDmN7AlkoqxhPD-QVjHBpHzxTdM-AdM4OB1lXj8xJHLXoYF0b3cDj9PAHFybHsAjq87L0V-PtG4QozGqYpdcP8nQ2kf3XC-o8gDiMet5vSkmodBdVCGyAW6BEAF3w-aYxWJwRLqtRzQ82F1DCsM83KzWl5mUwCspD34rn4V35B6BFB0B5oc?purpose=fullsize](https://images.openai.com/static-rsc-4/-qVR0rq8khtgbZacQXbCCZR8DrSgaDBsveNg7i3BOf2R7GxzhSintBfan3RD-c7k34w6Itge5ryTmJ-N3-QU74xkNg6157KFuIBOVU27lopT6tlZx5e1gLutnV6icft0eQsYuLnNisOTfudAmSGXeKLATEW9j-WnCBIZzynPX_0?purpose=inline)

6

Types:

- Packet loss
- High latency
- Partial connectivity (one service can reach, another cannot)
- Port open but no response

👉 Classic production bug:

> `curl` works sometimes… sometimes hangs

---

## 🔥 3. Resource Exhaustion (SILENT KILLER)

![https://images.openai.com/static-rsc-4/MwcWAWjpoWrXb2ZHIptWQk4z73iZ8l0XwYTfAMZQP7emkjsW-S9BLdm_zaSFMqTk1yG0ljnUNog8MkT9Wflt1PtycXU_h4Lnh7SpLebqE0wabxU_r_p6CekAjXTTglQD2masxCnUueyFSgrH3rhfObdsbCDRA-P-uoEN3kQ_2yOK5fkZyruCHaC-AGYI8tGz?purpose=fullsize](https://images.openai.com/static-rsc-4/yJ06DSH9E2QBMYatZSXW4puf91IF7-1kq1WKtNHlkqHnJ9no6LTnHvpHxLF9LPlnr2jf2VeZjkS8l1xh-YNaW8PdfomcRSEogOB4bb9mO2y_oekBOH8VtgxOJzdyiktO6EGcEhCUWPzo3r6zBTozTtNLtYjxCu85U-qfR_nJVys?purpose=inline)

![https://images.openai.com/static-rsc-4/0YbAkfx1uqdHIQUfdZ37N4oZ-HGGLVM4qxTW4U6KQ66dlpQiL0nQkS6cEO-ONQuHrMaqdmozLbXYubPZc5IXBJTPKfpzPQSuQ_H2zkwlMgzTY37W8Yenq748egtBP_BZODqSgg15GhmA3Q1LWN3OsKXW_wpAd5WFt5VNmg2a1DRJSIuceBAJqwPz_spN4p4b?purpose=fullsize](https://images.openai.com/static-rsc-4/CUaV65XTMtuCjpQy5sJ8aB9dTKjbdb-mddNU-XUqMY-RrWY_lwMKz2HTQfvHXVuLlu2dbQui_xB1EavgUC3bcEyZLsAgiiTY9QiBxLCCi1jIXsRyY8A6DXJnCestXDCG3v15Tj78P-6A0wOFJayZiEhP8NemR9x66Jfv9qha6lQ?purpose=inline)

![https://images.openai.com/static-rsc-4/W2TRa4XqFTK2gdqBm3WGo7uD8Ixjsl_8VY_Zq0RFnh1MIOIW6FTgGvoSruu0t6Q_q3wqJWnOYxXakvEYoLp1NjCSwsoLJdSIrO3whYHF4PGFxdwM8Vx2EpeezY83PKXPGiT3gdFPRC90zPXF3jD5C-gDu_6V6BSMsaIYPtU5B0zRrmz4X8_Tdh0SsMNeRtPX?purpose=fullsize](https://images.openai.com/static-rsc-4/wbFAZ8VIJLVrAzc43gODHEkZJ4RO2uG3TJklT1RTOVUYBS1eNt60h3QEs-9wHxh8jlbpJXKtqQzXCZ6jDRMLP6UPIkHsPgmXLy0iNqsBxiswVjLAgs_Kh9DBMoNZHQiOpaMvN2PprLxgf2ON2NwNqulr3gTc1A4DEsRGmzx7fcE?purpose=inline)

6

Breaks due to:

- CPU spike
- Memory leak → OOM kill
- Disk full (`No space left on device`)
- File descriptor limit (`too many open files`)

👉 Real-world:

> App doesn’t crash… just becomes slow and useless

---

## 🔥 4. Configuration Mistakes (VERY common in DevOps)

![https://images.openai.com/static-rsc-4/az6ilJ4MKnE2x5cMHbNCF8REe18wDb8n6d38oq0C3yi42sO8r9VPD2oJYQBPV0od7jDOrfxhtluwe2w3VG-htypzz94BH7sCMlt5tB0acwxrjovDuoo8gw5KCWc5dPgWQoEOIu200fp2wlMF2k9lGISfZ0uYYZlv-Ae0HzhIYJtd2TgkG9OvVXkUHpLR28C2?purpose=fullsize](https://images.openai.com/static-rsc-4/taG5howPaWEUPhChVX_lpmEbY62HWU0YAMLk2SixwsiF5VXRySg1EECLt5Jmi6psmV-PDYtoEx2hh3dIYf4JOlNlxEKhw_H-63oI2HwmffnPK0iYRGALg7iZsbU9sbqG9FXMEtep_iGEBi0Zdj9yUHNqkprcnksuT_4IBsKcD5U?purpose=inline)

![https://images.openai.com/static-rsc-4/nL55KmI44gqYvpKFCT39VJQTRlaKE4J7uK3dYtM1mhgtYu2i4buY6BUGJj8GLCzuLqtb-WZmUaJC52b_2EwhetHOuL5bIYRy0P_N-ZRk6VtHyO2L0-GvmTg2VhYWWKlwHRnRUlwsu3-P5HyxOkWkUg_JKoLoB1e4t0Gw7fuStycixXBz7n81VEa-qQUZmnRd?purpose=fullsize](https://images.openai.com/static-rsc-4/1LJW4XcIAZvj3suhtCGS2YlTu5jJePvDLpq-k2qZj0VBi7aCYHlRZwLQYZN0ELVhci5qJ_ko4uKtleYsATJtp-cToICOsLe5rUzCgR3fqrtUevNqjR7XJZnYTP2WyBHL0aVT_avokW9MyBG30rWmeskTQEpL6kNa1ORq9NjXBR0?purpose=inline)

![https://images.openai.com/static-rsc-4/AVZ-VogSl93IitFyCXU-KRWhVRRvSEaKVpeeZGclQRlFDwQbgLL_Dzh6jWk_0KCsahyR_dMQtkvUyLoP-0fPMCwgKjPwpHGAvugSDe4HS4XtnfHWwPJ8SALrK3X7C2xeI7vac0I1E8ePMiBjXNA9JJNzmoHKigP47Mr8YJnYu3TB4oRiTpMrdf9oJC4Cj34D?purpose=fullsize](https://images.openai.com/static-rsc-4/dlhlBJIgUZ2yz-8hwbKerlCJ2vaUgWM0FbxfdGNRBNu5dWXRJKdJ_T9WUg8YoZN-v11SczxX1IBeVR3PfDxoUX6P6r-9CSozfkt9bbA1MkZPh-sgGjT1M0LpxKdFSVpY2yZdyDHAS6GMuQr1D9iaYBf7nO-Zgj2N8fbaehZpNb8?purpose=inline)

9

Examples:

- Wrong DB URL
- Missing env var
- Wrong port
- Secrets mismatch

👉 Dangerous because:

> Everything looks “correct” but system behaves wrong

---

## 🔥 5. Startup Order Problems (Race Conditions)

![https://images.openai.com/static-rsc-4/kLCUQeKGKFQqTomWhmUiHt5NBfwgDgPYiVkeufLn5I-jnMibanQU2D3yk5jcYqBGmUNU4vFwyuL8_yfZfkV5D97WjEkjqIUXWF9cDabN48zJFdz_uw2PwnXAI_KQ3qqY-oeTPTJZEUfvmmi4o-BnevLoro-gHuco6h4G_NqpxilSMq8b-fhyLWLKjUozSrdS?purpose=fullsize](https://images.openai.com/static-rsc-4/baFHN4CmmTi6wpk5yPQNrYpa3QmsnKVu7ckVopT0-7v2_gajlXt6B0flD9XXcXGTb93VKXLBoxBLXB-MZdTspopC9TWyihi0SWi4yLgQXvnJQEurYuXrXco_76ZoVNm8kzT66ygCL4MD8_wj4k4xNRirRlBvqWFtB361a-7Lpy4?purpose=inline)

![https://images.openai.com/static-rsc-4/K3ZzVhOWv87v2bUI1r3NdR4cn8jM9YeZ1wqzIaA55IqXhmptkZnhGfimDMcJ9xb6ZY0K7JNziZAfhkXPcJEBdfI62JNKfHeRHB7Hr5dhIz51MYUahe1NlIE4c6bOtpppXA_7Sx8MprzPgFy40DjtIGU6GCifhyVZiEBp-HaZ2bBY3iI40UL9-SoDRDGtuAQ3?purpose=fullsize](https://images.openai.com/static-rsc-4/pGcbyiuXgtahdEFwj-DzXvpeg_XTpeTNYTGabqkqfV7_pNkbtDQ-gfvygTy0InnDgGcr1rsbiFxAyktD7BMXcGiKiYGFOUdPZJ9SKXmY7V64Y_utYoKl9PynaPygg4RQurviNQ-ZHhINirnVVb6o0owvCauX51dDIkCGjLUK4o4?purpose=inline)

![https://images.openai.com/static-rsc-4/PlHZ3OXuJg0Nsiszm1UhtG36tWAjjWa3nXu1wTGjthOdNfn9wpUAeZ25bm1ovo0aZantLuFz_Eq6ilLHpN6vTfYgWaywWCrojLbw1HL7UpctT05WRmCZwYP4YAg7lewzzfQCnzbgAPwHAdGM-IZNtODKNivp5BEa2WCD-cmpn5i0qU1m4_Jy-IhiSPIzRoHE?purpose=fullsize](https://images.openai.com/static-rsc-4/fM4RTBRE_1p10sJwqMtKa48BsGZ4xv7g5btTHP4v1qj2Jcwys2DNW6RGjUmTSDxAV4PMaZQjXeu82d9JzZ1yO5DwL88-rRV11OHK8kkdhSIz8H5dw1NSEi-g3ZUmXvgdZDA-t5q8vnYFbMvPUPDUCJ_KEane7K3YJtSHTMDHqcA?purpose=inline)

6

Example:

- Cart starts before Redis is ready

Result:

- Crash loop
- Intermittent failures

👉 Real issue:

> “Works locally, fails randomly in prod”

---

## 🔥 6. Data Problems (underrated)

![https://images.openai.com/static-rsc-4/ZEvIJlhe9sr6zTWukW37rjf7ysg9Gra6vdDyVC5QgOu-tqHTz4W7twxZpjbjlHJBZ4jnPkpBfYofgCVm_mYtdq4JSKMaV-8FxBt_27grNFI4q3z1VvEGYVdqnP9ZlTxjqKPaq32lpnXbj0k9GZnNIt8N92ejnetNxx_KJTC-unjlfb8xEUGqJCy8Kel2t3jJ?purpose=fullsize](https://images.openai.com/static-rsc-4/nnQyQcjh7dRLXrEOIzjs8vddjE6TTsR5qMg5P8WgLlTb4_n0R_mKFiL_nodgh3N2QYx8YUg1DLJgI41FpP_XsXfHmh3i8G-kIX6rZpTzacDnFdFhSLxQyiJ9WQd0IoNix5N2juPoXiydTCLDftt3381yu0QxEpD_4YpSBFqm6vY?purpose=inline)

![https://images.openai.com/static-rsc-4/hLrML6mQsOZ4R_sZ2WNf-H426h6JyCYXuMCCloVg888HfLX1tNxCgmqjCEYfoKxQR-Cx5HCyVb0Se7bCiww2Ez9qwcaNDSMRRjuxuFDRNXOpOI31-VHw3cUcICj1v2sxNWozj3kBF4W7yZ8FbJV-toVs0sVwOWgSjMmWBkiymPQ_Ke8eC0LpowtUVt2Sl02E?purpose=fullsize](https://images.openai.com/static-rsc-4/phJ62ImjR5fMQFxh1sPJQ1IM9gZ0lM5lxs8bshqAdh-gk6qgsQSv0I7a6PI_wOJ2NlSYBEnDac95dw1nOc6iuQHCg3VFKterIXMrZVPnnncQcT61UeJtO1DAwuTI-oU0m6a_psYlvRFdyXE2sUGO_OBtNExyD5BzL1Sn-xUQCEA?purpose=inline)

![https://images.openai.com/static-rsc-4/eULlSprgtFogAw5Cx1NtoiudhOtceMwo46XgDaXVgtzayyYv29UYWrMMwNxwvc4dDe8rRO5N85nwcP0YwUr5RiE0nfmj9GvJDoeY1QaFxCCBa4y0uHLnaedyJPui4GfJt1ErYt3yKgkIZV5DD4SXbgkZxRG0Y6wRQh3JisXURBoiSkcKLhhKpVJ53tJODd5C?purpose=fullsize](https://images.openai.com/static-rsc-4/AqWcgvj2r8JSAEYJ02PgYXIIOpsc80flEGMFbVW48aDpcZHbO65vEWW7qryI8iKx9RwwTs6YX-o9wuqCWKt1zfGGp5CFQkaCfr08znvYSBlCfrdxUnfCWUUJFmL9vZU1D00WGv2Mv-_J4S8Jfac6anPYhMx8tfa8yTch7USxFq0?purpose=inline)

7

Examples:

- Unexpected data format
- Null values
- Corrupt records

👉 Production reality:

> Code is fine, data is broken

---

## 🔥 7. External Service Failures

![https://images.openai.com/static-rsc-4/HsqZ69ArVX0BFZGe43FXpVJP9L9JE5TRx5_XHesK3nKPh_6uRvf0YYO2xbkjr-vi3sfgRUhz3AxUhATZw5zfBfkDb8-fbKmzl_JSTX7_xfcocbM6JEbgRJ9ov36Nns0RoYdikToIiuuo81KGlaGfqlFI5uXxQ2T-Lu6PYzUSirxGtKUYbROSFIcqA5RV3S9m?purpose=fullsize](https://images.openai.com/static-rsc-4/0I1NAxeS-BuIQPBX9rNnLjmQl1aMNT3lLy1B26oqyLvXA0n-i7tDiTaXMhYiap9rxJYwwf3PmXUQM5AcHppzf9WM7k3KUrdGlTu2Pdw2fmAFdYMDjL2CweurPPnzqb9PPoXjOZOuTJobSxdDQMmn1KnY1eKjENQfFOWWEk2tsX4?purpose=inline)

![https://images.openai.com/static-rsc-4/yuSajv7SHY0LLKZ9XiYci649sRyhZHzxvyyV0srvQgRAkz82m3Daap11xJaneMbMoWSqJh5sjvQTHLqlvm2sQYsNIRnd7QHoBw7ZPGc8ZZOZuUIvXsZR94-wu7FweNJurGBFayut-Zg1AOxTf35_GBVV_cw85cOFHM3RUXv2-tQFARGkRMb7KJHvlI2fq8I0?purpose=fullsize](https://images.openai.com/static-rsc-4/RWFlrAnGzyw4oxK56fdNVNW10B_IbI7SvkINcrhi8VVW9-2j6okQzbGZ68t5YPEKQ_guMzncewtIjizpkq2jbNw1dFLSuUTd6TN7hFgDij3Qvh6noT3GRAJiXoRRW4W_Z7WKSioGbBejV0w81-1vzLh5_40nbQBiq7WkAmqIYV8?purpose=inline)

![https://images.openai.com/static-rsc-4/iBDcaKSWDr1xAzaAbyDHF7HZoukO0Y88zt1wlnISW9yw16lZ1Kl_vvOJgZUrL5OG3_k5ZAfvxS4wCLlrWEe2SN0_V2_U6CymuvoN_w3sx-VeVOBqrJT1z_PZiiZz_e94dV4E96t2U3pmGjYoBhhFchqz66eAwxwHSn_QQZxi5bQcyI_BtvMT7sdJnO9Wq2uJ?purpose=fullsize](https://images.openai.com/static-rsc-4/7OBJlgiuGD2Sqy67abt5pUtQ8lBiKC3t2wqk7wjnexbdA7Fw5sKSIVrh_V8wa5IgThdPIXKyOKlkliFS2i4KyvxSvo-nfw5lpVo_NPlh1pV-cnFj_o9GR89LcB4RSnNCTEDkjC9YyPdqY3QZpngnIVYFIZuUL86A_RUUeQLJzZ8?purpose=inline)

7

Examples:

- Payment API down
- Email service slow
- Rate limits hit

👉 You can’t fix it — but must handle it

---

## 🔥 8. Deployment Issues (DevOps classic)

![https://images.openai.com/static-rsc-4/79UzBY4kyXOxt9LBVhF6uBZSRZrfiM4jIzhphs6s9vRYJ37-Abowv7kU0BuoFJHihxA2zUEsiEEexq2kAPGUQQC4tSUnAVYXrhWTtVlOVa80CysDcMYI_cKohi8HIkDTqRoZAtEXAPyOp-WQivsQ4VBhQ75IdZObNLxcwF3DjW7-shet66tPeCcA6zNOjIG0?purpose=fullsize](https://images.openai.com/static-rsc-4/PqPnN3_FZ1bfpWrBBu7uwKvCGwt0xYl5j5LLWznjUH3y3zEGNPLn6jJ_XI1HPm1Vgbqz3UdBTEXk9jxbhCE_54Kl-n5m9caSd67ofxkuxc1kJaXVS-YnlDsgU-xOyeTFG_0N8MwiDoisFBk-Lt9pwosDRWMWBimcjE_01fF_BD8pGF2MZmnItjGe63z4QzQR?purpose=inline)

![https://images.openai.com/static-rsc-4/X-RiXt0Tc9APAa65nRPkMcwhojcYLNvQ4ickfHCTnMF5LF9IjYwEUhdHhhHLU3la-G9Dmy6XT1nVpfFKZtKT5v4inxE3rwuN4e_aKrULmsYwpGYtOA0obYcTCi7ElOkcaomAiQUSPM2LpzGdLv_KdtdMdmRDZ9toLAENY1eTapEyNebYj4h_AUismLlfKYHo?purpose=fullsize](https://images.openai.com/static-rsc-4/8O3UDx8J9_Yaw3gh4T48CrwloD4-aM1nGIxAHmI2Cezpqc0A7GTDDqnUpXaLPyzr6_fa6qqBMsUgDY7NrZ6oEvldaLkGc2-vgm3XaBJi9fyVKVSBuho4ijUND35mmr3LCBmd9pI-H0SUCFfl4sg4mNRyYdHicYnL5ioE62Z6Y8A?purpose=inline)

![https://images.openai.com/static-rsc-4/LukB2eBwI8rbpm4BcDLRf5w2I0l2yHy8mGuxNDXJ9rbOr3Rg9zetU09GF_I_HyNXUgC_OgNeZmm4dYzBVILd2tusMBLHpT8wlZtJlmcCq0sV6ilYMhvjzlDcONHQCWPlGbMaB60n5ef3TYIE68iGLbpDBItYUdldbDHI7uuAZiABMLx_-w8DTqx480_mMah0?purpose=fullsize](https://images.openai.com/static-rsc-4/C2eG_mjWst8xcoAVSMsrkz71qhGTuZNt-18CrF3fW-SexPMME83Slfv6Gh7HfyNv5Rih8FEfUWN7nLIuJEmy1uMRlIY9jwUqoHY1b5yq3AthO2tN-2yrncjA3WiQwCiWttctxUVPMSYMacAG2vaUXd5pVju_DS1W28s9FZSQ3Lo?purpose=inline)

7

Examples:

- Wrong image version
- Partial deployment
- Broken config pushed

👉 Real fear:

> “Deployment caused outage”

---

## 🧠 The REAL mental model (important)

All production failures fall into:

1. **Dependency**
2. **Network**
3. **Resource**
4. **Configuration**
5. **Timing (race conditions)**
6. **Data**
7. **External systems**
8. **Deployment**

---

## 💣 Now I’ll push you (important)

Pick **ANY 2 from below and simulate:**

- Redis slow (not down)
- Disk full inside container
- Wrong env var
- Service starts before dependency
- CPU spike

---

## 🚀 What I want from you next

Don’t just try — come back with:

- What you broke
- What you observed
- Where you got stuck

Then I’ll turn it into:  
👉 **Interview story + LinkedIn post + real SRE narrative**

This is exactly how you build a **serious DevOps/SRE profile**.