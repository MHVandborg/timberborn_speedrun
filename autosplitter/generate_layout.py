"""Run once to generate timberborn.lsl with the correct paths for this machine."""
import os, pathlib

asl_path = pathlib.Path.home() / "Documents" / "Timberborn" / "timberborn.asl"

xml = f"""<?xml version="1.0" encoding="UTF-8"?>
<Layout version="1.5">
  <Mode>Vertical</Mode>
  <X>0</X>
  <Y>0</Y>
  <VerticalWidth>300</VerticalWidth>
  <VerticalHeight>500</VerticalHeight>
  <HorizontalWidth>600</HorizontalWidth>
  <HorizontalHeight>150</HorizontalHeight>
  <Components>
    <Component>
      <Path>LiveSplit.Title.dll</Path>
      <Settings>
        <Version>1.8</Version>
        <ShowGameName>True</ShowGameName>
        <ShowCategoryName>True</ShowCategoryName>
        <ShowAttemptCount>True</ShowAttemptCount>
        <ShowFinishedRunsCount>False</ShowFinishedRunsCount>
        <OverrideTitleFont>False</OverrideTitleFont>
        <CenteredTitle>True</CenteredTitle>
        <SingleLine>False</SingleLine>
      </Settings>
    </Component>
    <Component>
      <Path>LiveSplit.Splits.dll</Path>
      <Settings>
        <Version>1.5</Version>
        <VisualSplitCount>6</VisualSplitCount>
        <SplitPreviewCount>1</SplitPreviewCount>
        <AlwaysShowLastSplit>True</AlwaysShowLastSplit>
        <ShowBlankSplits>True</ShowBlankSplits>
        <LockLastSplit>True</LockLastSplit>
        <ShowColumnLabels>False</ShowColumnLabels>
        <Columns>
          <Column>
            <Name>+/-</Name>
            <Type>Delta</Type>
            <Comparison>Personal Best</Comparison>
            <TimingMethod>Current Timing Method</TimingMethod>
          </Column>
          <Column>
            <Name>Time</Name>
            <Type>SplitTime</Type>
            <Comparison>Personal Best</Comparison>
            <TimingMethod>Current Timing Method</TimingMethod>
          </Column>
        </Columns>
      </Settings>
    </Component>
    <Component>
      <Path>LiveSplit.Timer.dll</Path>
      <Settings>
        <Version>1.8</Version>
        <TimerHeight>50</TimerHeight>
        <TimerFormat>1.23</TimerFormat>
        <ShowGradient>True</ShowGradient>
        <TimingMethod>Current Timing Method</TimingMethod>
      </Settings>
    </Component>
    <Component>
      <Path>LiveSplit.ScriptableAutoSplit.dll</Path>
      <Settings>
        <Version>1.0</Version>
        <ScriptPath>{asl_path}</ScriptPath>
        <CustomSettings>
          <Setting id="first_log"      type="bool">True</Setting>
          <Setting id="first_house"    type="bool">True</Setting>
          <Setting id="pop_5"          type="bool">True</Setting>
          <Setting id="first_forester" type="bool">True</Setting>
          <Setting id="pop_10"         type="bool">True</Setting>
          <Setting id="pop_20"         type="bool">True</Setting>
        </CustomSettings>
      </Settings>
    </Component>
  </Components>
</Layout>"""

out = pathlib.Path(__file__).parent / "timberborn.lsl"
out.write_text(xml, encoding="utf-8")
print(f"Written: {out}")
print(f"ASL path used: {asl_path}")
