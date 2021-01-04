/*
 * $Id: replay.d,v 1.4 2005/09/11 00:47:40 kenta Exp $
 *
 * Copyright 2005 Kenta Cho. Some rights reserved.
 */
module abagames.gr.replay;

private import std.stdio;
private import abagames.util.sdl.recordableinput;
private import abagames.util.sdl.pad;
private import abagames.util.sdl.twinstick;
private import abagames.util.sdl.mouse;
private import abagames.gr.gamemanager;
private import abagames.gr.mouseandpad;

/**
 * Save/Load a replay data.
 */
public class ReplayData {
 public:
  static const string dir = "replay";
  static const int VERSION_NUM = 11;
  InputRecord!(PadState) padInputRecord;
  InputRecord!(TwinStickState) twinStickInputRecord;
  InputRecord!(MouseAndPadState) mouseAndPadInputRecord;
  long seed;
  int score = 0;
  float shipTurnSpeed;
  bool shipReverseFire;
  int gameMode;
 private:

  public void save(string fileName) {
    auto fd = new File(dir ~ "/" ~ fileName, "wb");
    fd.writef!"%d"(VERSION_NUM);
    fd.writef!"%d"(seed);
    fd.writef!"%d"(score);
    fd.writef!"%f"(shipTurnSpeed);
    if (shipReverseFire)
      fd.writef!"%d"(1);
    else
      fd.writef!"%d"(0);
    fd.writef!"%d"(gameMode);
    switch (gameMode) {
    case InGameState.GameMode.NORMAL:
      padInputRecord.save(fd);
      break;
    case InGameState.GameMode.TWIN_STICK:
    case InGameState.GameMode.DOUBLE_PLAY:
      twinStickInputRecord.save(fd);
      break;
    case InGameState.GameMode.MOUSE:
      mouseAndPadInputRecord.save(fd);
      break;
    }
    fd.close();
  }

  public void load(string fileName) {
    auto fd = new File(dir ~ "/" ~ fileName);
    int ver;
    fd.readf!"%d"(ver);
    if (ver != VERSION_NUM)
      throw new Error("Wrong version num");
    fd.readf!"%d"(seed);
    fd.readf!"%d"(score);
    fd.readf!"%f"(shipTurnSpeed);
    int srf;
    fd.readf!"%d"(srf);
    if (srf == 1)
      shipReverseFire = true;
    else
      shipReverseFire = false;
    fd.readf!"%d"(gameMode);
    switch (gameMode) {
    case InGameState.GameMode.NORMAL:
      padInputRecord = new InputRecord!(PadState);
      padInputRecord.load(fd);
      break;
    case InGameState.GameMode.TWIN_STICK:
    case InGameState.GameMode.DOUBLE_PLAY:
      twinStickInputRecord = new InputRecord!(TwinStickState);
      twinStickInputRecord.load(fd);
      break;
    case InGameState.GameMode.MOUSE:
      mouseAndPadInputRecord = new InputRecord!(MouseAndPadState);
      mouseAndPadInputRecord.load(fd);
      break;
    }
    fd.close();
  }
}
