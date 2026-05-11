how can developers cheat us that code coverage canoot be met in particulars secnarios and asks us to pass them

They usually do not say “I’m cheating.” They frame it as necessity.

Your job is to separate legitimate exceptions from laziness.

Common ways developers game coverage:

1. Writing superficial tests

They execute code with weak assertions just to raise coverage.

Example:  
`assertTrue(true)`  
or only checking non-null.

Looks compliant, proves little.

2. Excluding files from coverage

They ask to exclude:

- utility classes
- config
- exception handlers
- generated code

Some exclusions are valid. Many are convenient escapes.

3. Marking code as “hard to test”

Examples:

- static methods
- legacy code
- third-party integrations
- time-dependent logic

Sometimes true, often a design smell they don’t want to fix.

4. Moving logic to untested paths

Critical logic gets hidden in places with weaker test enforcement.

5. Asking for temporary Quality Gate bypass

“Urgent release”  
“Production hotfix”  
“Business deadline”

Temporary bypass becomes permanent habit.

How you respond:

Ask:  
“What specifically makes this untestable?”

Not:  
“Okay, we’ll skip it.”

Then ask:

- Can it be refactored?
- Can it be integration tested instead?
- Can mocking solve it?
- Is branch coverage actually the issue?
- Is this exception documented?

For exclusions:  
Require justification per file, not blanket approval.

For bypass:  
Force:

- risk acknowledgment
- approval trail
- follow-up task to restore compliance

Hard truth:

If bypass is easy, people optimize for bypass.

Engineering discipline is not saying “no” to everything.

It is making exceptions expensive enough that only real exceptions survive.