# Install the Claude edition

1. In Claude, enable **Code execution and file creation** under **Settings > Capabilities**.
2. Open **Customize > Skills**.
3. Click **+**, choose **Create skill**, then **Upload a skill**.
4. Upload `clean-my-ai-harness-claude.zip` and enable it.
5. Start a new chat with the project you want to review and say:

> Use clean-my-ai-harness to review the AI setup for this project. Start read-only. Show me one plain-English report. Do not change anything until I approve each change.

The report will say what Claude could not see. If your instructions live outside the project, add or export them before running the review.

To remove the cleaner, disable or delete it under **Customize > Skills**. That does not undo changes you previously approved; use the rollback instructions from that run.
