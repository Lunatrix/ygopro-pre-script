--Myutant Evolution Lab
--
--Script by JoyJ
function c101102092.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101102092+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101102092.activate)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x258))
	e2:SetValue(c101102092.atkval)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101102092,1))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101102092.drtg)
	e3:SetOperation(c101102092.drop)
	c:RegisterEffect(e3)
end
function c101102092.spfilter(c,e,tp)
	return c:IsSetCard(0x258) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c101102092.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.GetMatchingGroup(c101102092.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101102092,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101102092.atkvalfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x258)
end
function c101102092.atkval(e,c)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(c101102092.atkvalfilter,tp,LOCATION_REMOVED,0,nil)
	return g:GetClassCount(Card.GetCode)*100
end
function c101102092.drtgfilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x258) and c:IsType(TYPE_MONSTER)
end
function c101102092.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c101102092.drtgfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101102092.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c101102092.drtgfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
