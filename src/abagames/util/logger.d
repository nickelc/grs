/*
 * $Id: logger.d,v 1.2 2005/07/03 07:05:23 kenta Exp $
 *
 * Copyright 2004 Kenta Cho. Some rights reserved.
 */
module abagames.util.logger;

private import std.conv;
private import std.stdio;
private import std.string;

/**
 * Logger(error/info).
 */
version(Win32_release) {

private import std.string;
private import std.c.windows.windows;

public class Logger {

  public static void info(string msg, bool nline = true) {
    // Win32 exe crashes if it writes something to stderr.
    /*if (nline)
      std.cstream.derr.writeLine(msg);
    else
      std.cstream.derr.writeString(msg);*/
  }

  public static void info(double n, bool nline = true) {
    /*if (nline)
      std.cstream.derr.writeLine(std.string.toString(n));
    else
      std.cstream.derr.writeString(std.string.toString(n) ~ " ");*/
  }

  private static void putMessage(char[] msg) {
    MessageBoxA(null, std.string.toStringz(msg), "Error", MB_OK | MB_ICONEXCLAMATION);
  }

  public static void error(char[] msg) {
    putMessage("Error: " ~ msg);
  }

  public static void error(Exception e) {
    putMessage("Error: " ~ e.toString());
  }

  public static void error(Error e) {
    putMessage("Error: " ~ e.toString());
  }
}

} else {

public class Logger {

  public static void info(string msg, bool nline = true) {
    if (nline)
      stderr.writeln(msg);
    else
      stderr.write(msg);
  }

  public static void info(double n, bool nline = true) {
    if (nline)
      stderr.writeln(std.conv.to!string(n));
    else
      stderr.write(std.conv.to!string(n) ~ " ");
  }

  public static void error(string msg) {
    stderr.writeln("Error: " ~ msg);
  }

  public static void error(Exception e) {
    stderr.writeln("Error: " ~ e.toString());
  }

  public static void error(Throwable e) {
    stderr.writeln("Error: " ~ e.toString());
    if (e.next)
      error(e.next);
  }
}

}
