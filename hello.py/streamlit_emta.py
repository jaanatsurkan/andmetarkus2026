import streamlit as st
import pandas as pd
import duckdb
import seaborn as sns
import matplotlib.pyplot as plt

st.write("# Ettevõtluse statistika maakondade lõikes")

data = pd.read_csv("emta_data.csv")



col1, col2 = st.columns(2)

with col1:
    aasta = st.selectbox("Aasta", options=sorted(data["aasta"].unique(), reverse=True))

with col2:
   kvartal = st.selectbox(
        "Kvartal",
        options=duckdb.sql(f"SELECT DISTINCT kvartal FROM data WHERE aasta = {aasta} ORDER BY kvartal")
    )

count_by_country = duckdb.sql(f"""
    SELECT 
        maakond,
        count(DISTINCT registrikood) AS ettevotete_arv
    FROM data
    WHERE aasta = {aasta} AND kvartal = {kvartal}                              
    GROUP BY maakond
    HAVING maakond NOT NULL   
    ORDER BY ettevotete_arv DESC                                                        
""").df()

"Seda on ka näha"
st.bar_chart(count_by_country, x="maakond", y="ettevotete_arv", sort=False)

fig = plt.figure(figsize=(10, 8))
sns.barplot(count_by_country, x="maakond", y="ettevotete_arv")
st.pyplot(fig)

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


import pandas as pd
import streamlit as st
import duckdb
import pydeck as pdk

st.write("# Ettevõtete arv maakonniti")

# 1. Maakondade koordinaadid
maakond_koord = pd.DataFrame({
    "maakond": [
        "Harju maakond","Hiiu maakond","Ida-Viru maakond","Jõgeva maakond",
        "Järva maakond","Lääne maakond","Lääne-Viru maakond","Põlva maakond",
        "Pärnu maakond","Rapla maakond","Saare maakond","Tartu maakond",
        "Valga maakond","Viljandi maakond","Võru maakond"
    ],
    "lat": [59.4,58.9,59.3,58.7,58.9,58.9,59.3,58.1,58.4,59.0,58.3,58.4,57.9,58.4,57.8],
    "lon": [24.7,22.6,27.4,26.4,25.6,23.5,26.3,27.1,24.5,24.8,22.5,26.7,26.0,25.6,27.0]
})

# Abi funktsioon nimekuju ühtlustamiseks
def normaliseeri_maakond(x):
    if pd.isna(x):
        return x
    x = str(x).strip().lower()
    
    # eemaldame erinevad lõpud
    x = x.replace(" maakond", "")
    x = x.replace("maa", "")  # nt Tartumaa -> tartu, Pärnumaa -> pärnu
    
    # erijuhud
    x = x.replace("harju", "harju")
    x = x.replace("hiiu", "hiiu")
    x = x.replace("ida-viru", "ida-viru")
    x = x.replace("jõgeva", "jõgeva")
    x = x.replace("järva", "järva")
    x = x.replace("lääne", "lääne")
    x = x.replace("lääne-viru", "lääne-viru")
    x = x.replace("põlva", "põlva")
    x = x.replace("pärnu", "pärnu")
    x = x.replace("rapla", "rapla")
    x = x.replace("saare", "saare")
    x = x.replace("tartu", "tartu")
    x = x.replace("valga", "valga")
    x = x.replace("viljandi", "viljandi")
    x = x.replace("võru", "võru")
    
    return x

# 2. Ettevõtete arv maakonna kaupa
ettevotted = duckdb.sql("""
    SELECT
        maakond,
        COUNT(DISTINCT registrikood) AS ettevotete_arv
    FROM data
    WHERE aasta = 2026
      AND kvartal = 1
    GROUP BY maakond
""").df()

st.write("Algandmed:", ettevotted)

# 3. Ühtlusta nimed
maakond_koord["maakond_key"] = maakond_koord["maakond"].apply(normaliseeri_maakond)
ettevotted["maakond_key"] = ettevotted["maakond"].apply(normaliseeri_maakond)

df_map = maakond_koord.merge(
    ettevotted[["maakond_key", "ettevotete_arv"]],
    on="maakond_key",
    how="left"
)

df_map["ettevotete_arv"] = df_map["ettevotete_arv"].fillna(0).astype(int)

df_check = maakond_koord.merge(
    ettevotted[["maakond", "maakond_key", "ettevotete_arv"]],
    on="maakond_key",
    how="left",
    indicator=True
)

st.write(df_check[["maakond_x", "maakond_y", "_merge", "ettevotete_arv"]])

# 4. Kaardikiht
layer = pdk.Layer(
    "ScatterplotLayer",
    data=df_map,
    get_position="[lon, lat]",
    get_radius=20000,
    get_fill_color=[0, 100, 255, 120],
    get_line_color=[0, 60, 180, 180],
    line_width_min_pixels=1,
    pickable=True,
    stroked=True,
    filled=True,
)

# 5. Vaade
view_state = pdk.ViewState(
    latitude=58.7,
    longitude=25.0,
    zoom=6.7,
)

# 6. Tooltip
tooltip = {
    "html": """
        <b>Maakond:</b> {maakond}<br/>
        <b>Ettevõtteid:</b> {ettevotete_arv}
    """,
    "style": {
        "backgroundColor": "white",
        "color": "black"
    }
}

# 7. Näita kaart
st.pydeck_chart(
    pdk.Deck(
        layers=[layer],
        initial_view_state=view_state,
        tooltip=tooltip,
        map_style="light"
    )
)