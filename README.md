# DSA Mastery Dashboard

A responsive, local-first DSA study tracker for Java interview preparation.

## What it does

- Pattern hierarchy across 16 major DSA families, with subpatterns and representative base problems.
- Problem-attempt logging: result, difficulty, minutes, trigger, idea/invariant, mistake, and optional problem URL.
- Automatic spaced review schedule at Day +1, +3, +7, +14.
- Review queue with "passed cold" and "struggled" actions.
- Concept notebook for trigger sentences and Java templates.
- Adaptive local practice-set generator that emphasizes weak or untouched patterns. The updated generator hides the pattern and recognition clue behind a reveal control, making the initial attempt more like a blind interview question.
- Progress stats, cold-solve rate, due reviews, study streak, resource links, and 24-week progression.
- JSON backup/restore.
- Optional Supabase email/password authentication and cross-device sync.
- Safer first cloud login: combines local records with existing cloud records for the same/first account, and avoids merging records across accounts once an account owner is known.

## AI coach integration

The AI coach is implemented as an optional authenticated Supabase Edge Function calling the OpenAI Responses API. It is not active until you deploy the function and add a server-side OpenAI API key.

The AI coach can:
- Analyze attempts, cold-solve results, review outcomes, study streaks, concept notes, and logged mistakes.
- Produce an evidence-based progress report that distinguishes observed facts from hypotheses.
- Build a personalized 7-day study plan for Java/DSA Big Tech SDE interview preparation.
- Generate targeted variations based on weak patterns and recorded mistakes.
- Answer study questions using the supplied progress history.
- Review pasted Java code for correctness risks, edge cases, complexity, and interview follow-ups. It does not execute the code.

### Privacy and cost
- The app requires the user to check an explicit consent box before any AI action.
- The app sends a bounded subset of study records (up to 150 recent attempts, 150 reviews, and 50 concepts) and any question/code the user submits.
- The request is routed through the authenticated `dsa-ai-coach` Edge Function. The OpenAI API key must remain in Supabase secrets, never in `index.html`.
- The function sets `store: false` for Responses API requests. This is not a promise of zero provider-side retention; provider data-use and retention policies still apply.
- OpenAI API usage may incur separate charges. A ChatGPT subscription does not automatically include API credits. Review API pricing and set spending limits before using the feature.
- Do not submit passwords, access tokens, or unrelated private information.

### Deploy the AI backend
1. Create an OpenAI API key from the OpenAI API platform and review API billing/pricing first.
2. Install/use the Supabase CLI and sign in: `npx supabase login`.
3. Link this project folder to your Supabase project: `npx supabase link --project-ref YOUR_PROJECT_REF`.
4. Add the API key as a server secret: `npx supabase secrets set OPENAI_API_KEY=YOUR_OPENAI_API_KEY`.
5. Optional: select a supported model with `npx supabase secrets set OPENAI_MODEL=gpt-5.5`.
6. Deploy the function from this folder: `npx supabase functions deploy dsa-ai-coach`.
7. Open the published dashboard, configure Supabase in Settings, and create/sign in to your own account.
8. In Supabase Dashboard → Authentication → Users, copy the UUID for your own account. Restrict the AI function to that account: `npx supabase secrets set AI_ALLOWED_USER_ID=YOUR_AUTH_USER_UUID`. This owner restriction prevents other people who might create accounts on a public site from using your API budget.
9. Open the AI coach tab, check the consent box, then test **Analyze my progress**.
10. If it fails, inspect Supabase Dashboard → Edge Functions → `dsa-ai-coach` → Logs. Never paste the OpenAI secret into GitHub, browser settings, screenshots, or chat.

The function source is at `supabase/functions/dsa-ai-coach/index.ts`. It checks the user's Supabase session, limits payload size, accepts only known actions, and does not execute submitted Java code.

## Run locally

Open `index.html` in a modern browser. Local mode saves to that browser's `localStorage`. Data does not automatically appear on another device until cloud sync is configured.

## Publish the website with GitHub Pages

1. Sign in to GitHub and create a new repository, for example `dsa-mastery-dashboard`.
2. Set the repository to **Public** if using the free GitHub Pages option for a personal repository, unless your account's plan supports Pages from a private repository.
3. Upload `index.html` to the repository's top/root level (not inside another folder). You may also upload `README.md` and `supabase-setup.sql` for reference.
4. Open the repository's **Settings → Pages**.
5. Under **Build and deployment**, select **Deploy from a branch**.
6. Select branch `main` and folder `/ (root)`, then save.
7. Wait for deployment, refresh the Pages section, and open the published `https://<your-github-username>.github.io/<repository-name>/` address.
8. Test that the dashboard opens on your phone and laptop. At this point, the page is online, but cloud sync is not yet enabled.

## Enable cross-device sync with Supabase

1. Create a project at Supabase and wait for the database to finish provisioning.
2. Open the project's **SQL Editor**.
3. Open the included `supabase-setup.sql`, copy all its SQL, paste it into the SQL Editor, and run it. Confirm the `dsa_progress` table was created.
4. In Supabase project settings, find the **Project URL** and the **publishable key** (or legacy `anon` public key). Copy these values. Never use the `service_role` or secret key in the browser.
5. Open the GitHub Pages website.
6. Open **Cloud sync / Settings**.
7. Paste the Supabase Project URL and publishable/anon key, then click **Connect**.
8. Enter your email and a strong password, then click **Create account**.
9. If Supabase requires email confirmation, open the verification email, verify the account, return to the website, enter the same credentials, and click **Sign in**.
10. On every other device, open the same published URL, enter the same Project URL and public key, and sign in with the same account. Your progress should load from the cloud.
11. Log a small test attempt on one device, wait for the status to say cloud synced, then refresh the website on the second device and confirm it appears.
12. Export a JSON backup periodically from **Settings & backup**.

## Important notes

- GitHub Pages hosts the static front end; Supabase stores authenticated progress.
- The Supabase public key is designed for browser use only when Row Level Security (RLS) is correctly enabled. The included SQL enables RLS and limits each row to its authenticated owner.
- Never put a Supabase service-role key or private AI key in `index.html`.
- If cloud sync is not configured, data remains only in that browser/device.
- Do not sign into different accounts in the same browser without understanding that each account has its own cloud data. Export a backup before switching accounts if you have important local-only records.
- The original practice-set generator remains deterministic and local. AI-generated variations are available separately through the AI coach after its backend is configured.
- This is a study tool, not a guarantee of interviews or offers.

## Suggested learning workflow

1. Watch one focused concept explanation or read a reference.
2. Attempt the base problem without looking at the solution.
3. Log the result honestly.
4. Record the trigger, invariant, mistake, and a reusable Java template.
5. Redo from a blank file on Day +1, +3, +7, and +14.
6. Use the practice-test tab weekly, without revealing the pattern until after the attempt.
