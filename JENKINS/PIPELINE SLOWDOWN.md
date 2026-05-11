𝗬𝗼𝘂𝗿 𝗖𝗜/𝗖𝗗 𝗣𝗶𝗽𝗲𝗹𝗶𝗻𝗲 𝗦𝗵𝗼𝘂𝗹𝗱𝗻’𝘁 𝗙𝗲𝗲𝗹 𝗟𝗶𝗸𝗲 𝗮 𝗪𝗮𝗶𝘁𝗶𝗻𝗴 𝗥𝗼𝗼𝗺  
  
A slow pipeline slows down the whole team.  
  
When every code change takes too long to build, test, and deploy, developers wait longer for feedback and releases become harder to ship.  
  
A few ways to reduce CI/CD time:  
  
• 𝗥𝘂𝗻 𝗷𝗼𝗯𝘀 𝗶𝗻 𝗽𝗮𝗿𝗮𝗹𝗹𝗲𝗹  
  
• 𝗖𝗮𝗰𝗵𝗲 𝗱𝗲𝗽𝗲𝗻𝗱𝗲𝗻𝗰𝗶𝗲𝘀  
Avoid downloading the same packages on every run. Caching npm, pip, or Docker layers can save a lot of time.  
  
• 𝗨𝗽𝗴𝗿𝗮𝗱𝗲 𝗿𝘂𝗻𝗻𝗲𝗿𝘀 𝗶𝗳 𝗻𝗲𝗲𝗱𝗲𝗱  
Sometimes the pipeline is not the issue. The runner might just need more CPU or memory.  
  
• 𝗦𝗲𝗽𝗮𝗿𝗮𝘁𝗲 𝗽𝗶𝗽𝗲𝗹𝗶𝗻𝗲𝘀  
PR checks, staging deployments, and production deployments should not always run the same full workflow.  
  
• 𝗥𝗲𝗱𝘂𝗰𝗲 𝗗𝗼𝗰𝗸𝗲𝗿 𝗶𝗺𝗮𝗴𝗲 𝘀𝗶𝘇𝗲  
Smaller images build, push, pull, and deploy faster. Multi-stage builds and minimal base images help a lot.