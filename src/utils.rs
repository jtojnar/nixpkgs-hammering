use std::{
    io::Write as _,
    process::{Command, Stdio},
};

pub(crate) fn optional_env(name: &str) -> Result<Option<String>, String> {
    match std::env::var(name) {
        Ok(value) => return Ok(Some(value)),
        Err(std::env::VarError::NotPresent) => Ok(None),
        Err(err) => {
            return Err(format!(
                "Unable to decode ‘{name}’ environment variable: {err}"
            ))
        }
    }
}

pub(crate) fn run_command_with_input(
    program: &str,
    args: &[&str],
    input: &str,
) -> Result<String, String> {
    let mut child = Command::new(program)
        .args(args)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .map_err(|err| format!("Unable to spawn program ‘{program}’: {}", err.to_string()))?;

    {
        let Some(mut child_stdin) = child.stdin.take() else {
            return Err(format!("Unable to acquire stdin handle of ‘{program}’"));
        };

        child_stdin.write_all(input.as_bytes()).map_err(|err| {
            format!(
                "Unable to write to stdin of ‘{program}’: {}",
                err.to_string()
            )
        })?;
    }

    let output = child
        .wait_with_output()
        .map_err(|err| format!("Unable to wait on ‘{program}’: {}", err.to_string()))?;

    let stdout = String::from_utf8(output.stdout).map_err(|err| {
        format!(
            "Unable to parse output of ‘{program}’ as UTF-8: {}",
            err.to_string()
        )
    })?;

    Ok(stdout)
}

pub(crate) fn indent(text: String, steps: usize) -> String {
    text.split("\n")
        .map(|line| " ".repeat(4 * steps * (!line.is_empty() as usize)) + line)
        .collect::<Vec<_>>()
        .join("\n")
}
