import streamlit as st
import pandas as pd
import duckdb

st.write("# Ettevõtluse statistika maakondade lõikes")

data = pd.read_csv("emta_data.csv")

maakond: str = st.selectbox("Maakond", options=data["maakond"].unique())

st.write(duckdb.sql(f"""
    SELECT
        kov,
        count(DISTINCT registrikood) AS ettevotete_arv,
        round(avg(kaive) / 3)::int AS keskmine_kuine_kaive,
        round(avg(kaive))::int AS keskmine_kvartaalne_kaive
    FROM data
    WHERE aasta = 2026 AND kvartal = 1 AND maakond = '{maakond}'
    GROUP BY kov
    ORDER BY keskmine_kuine_kaive DESC
""").df())