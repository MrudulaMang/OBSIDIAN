One-line interview answer:

“Shift left means moving validation, security, testing, and quality checks earlier in the development lifecycle so defects are caught sooner, reducing cost, risk, and release delays.”

----------
“Shift left” is not just “test before deployment.” That sounds like a checklist improvement. Shift left is a mindset change in the software delivery lifecycle.

The idea:

Work that normally happens late (right side of the timeline) should happen earlier (left side of the timeline), when fixes are cheaper, faster, and less risky.

Examples:

Instead of:  
Code → Build → Deploy → Security finds issue

Do:  
Code → Security scan during PR → Build → Deploy

Instead of:  
Production outage reveals bad config

Do:  
Policy checks + validation during CI

Instead of:  
Performance issue found in UAT

Do:  
Load testing earlier in pipeline

Instead of:  
Infra misconfiguration found after Terraform apply

Do:  
Static checks before apply

So shift left includes:

- Testing
- Security scanning
- Code quality checks (like SonarQube)
- Compliance checks
- Infrastructure validation
- Performance testing
- Dependency vulnerability scans
- Architecture reviews
- Threat modeling

The real principle:

The later you find a problem, the more expensive it becomes.

Your version mentions deployment, but challenge that thought: why stop there?  
Why not shift even further left—to design itself?

For example:  
A bad microservice boundary found in production is expensive.  
The same issue caught during architecture review costs almost nothing.

That is actual senior thinking.

------------


when was shift left introduced...

“Shift left” as a formal software testing term was coined in **2001** by **Larry Smith**, in his article _“Shift-Left Testing”_ published in _Dr. Dobb’s Journal_.

The idea itself is older than the term.

Even before 2001, good engineers were already doing parts of it:

- early design reviews
- unit testing before full integration
- catching defects during requirements/design instead of after release

But the phrase **“shift left”** gave it a clear model: if you imagine the SDLC timeline from left → right (requirements → design → coding → testing → release), then moving testing/security earlier means shifting it to the **left**.

Later it expanded beyond testing:

- **Shift-left testing** → test early
- **Shift-left security (DevSecOps)** → security checks during development, not just before release
- **Shift-left operations** → reliability, observability, rollback thinking during design
- **Shift-left compliance** → policy checks inside CI/CD

This is why in DevOps people say:

> Don’t inspect quality at the end. Build it from the beginning.

Important distinction:  
many people think shift-left means “QA starts earlier.”

That is too shallow.

Real shift-left means:  
**developers, testers, security, ops, and product all participate earlier—before defects become architecture.**

That is why mature teams value it. It is not a testing trick; it is a systems thinking discipline.